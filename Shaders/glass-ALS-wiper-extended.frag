// -*-C++-*-
#version 120

varying vec2 rawPos;
varying vec2 nPos;
varying vec3 vertPos;
varying vec3 normal;
varying vec3 refl_vec;
varying vec3 light_diffuse;
varying float splash_angle;
varying float Mie;
varying float ambient_fraction;

uniform sampler2D texture;
uniform sampler2D frost_texture;
uniform sampler2D func_texture;
uniform samplerCube cube_texture;
uniform samplerCube cube_light_texture;

uniform vec4 tint;
uniform vec3 overlay_color;


uniform float rain_norm;
uniform float ground_splash_norm;
uniform float frost_level;
uniform float fog_level;
uniform float reflection_strength;
uniform float overlay_alpha;
uniform float overlay_glare;
uniform float splash_x;
uniform float splash_y;
uniform float splash_z;
uniform float lightmap_r_factor;
uniform float lightmap_g_factor;
uniform float lightmap_b_factor;
uniform float lightmap_a_factor;
uniform float osg_SimulationTime;

uniform int use_reflection;
uniform int use_reflection_lightmap;
uniform int use_mask;
uniform float wiper_pos_left;
uniform float wiper_pos_right;
uniform int use_wipers;
uniform int use_overlay;
uniform int adaptive_mapping;
uniform int lightmap_multi;

uniform vec3 lightmap_r_color;
uniform vec3 lightmap_g_color;
uniform vec3 lightmap_b_color;
uniform vec3 lightmap_a_color;

float DotNoise2D(in vec2 coord, in float wavelength, in float fractionalMaxDotSize, in float dot_density);
float DropletNoise2D(in vec2 coord, in float wavelength, in float fractionalMaxDotSize, in float dot_density);
float Noise2D(in vec2 coord, in float wavelength);
vec3 filter_combined (in vec3 color) ;

void main()
{

vec4 texel;
vec4 frost_texel;
vec4 func_texel;

texel = texture2D(texture, gl_TexCoord[0].st);
texel *=gl_Color;

vec2 frost_coords;

if (adaptive_mapping == 1) {frost_coords = gl_TexCoord[0].st * 7.0;}
else if (adaptive_mapping ==2) {frost_coords = nPos * 7.0;}
else {frost_coords = vertPos.xy * 7.0;}

frost_texel = texture2D(frost_texture, frost_coords);
func_texel = texture2D(func_texture, gl_TexCoord[0].st);
float baseMask = func_texel.g;

bool dualWipers = (use_wipers == 1) && (wiper_pos_left > 0.0 || wiper_pos_right > 0.0);

float wipe = 0.0;

if (dualWipers) {
    float isRight = step(nPos.x, 0.0);
    float sweepCoord = 1.0 - clamp(nPos.y, 0.0, 1.0);
    float posL = 1.0 - abs(wiper_pos_left  * 2.0 - 1.0);
    float posR = 1.0 - abs(wiper_pos_right * 2.0 - 1.0);
    float paneWipe = mix(posL, posR, isRight);
    wipe = paneWipe * baseMask;
} else {
    // Legacy single wiper, static behavior wipe == mask
    wipe = baseMask;
}

float noise_003m = Noise2D(vertPos.xy, 0.03);
float noise_0003m = Noise2D(vertPos.xy, 0.003);


// environment reflection, including a lightmap for the reflections

vec4 reflection = textureCube(cube_texture, refl_vec);
vec4 reflection_lighting = textureCube(cube_light_texture, refl_vec);

vec3 lightmapcolor = vec3(0.0, 0.0, 0.0);


if (use_reflection_lightmap == 1)
	{
	vec4 lightmapFactor = vec4(lightmap_r_factor, lightmap_g_factor, lightmap_b_factor, lightmap_a_factor);

        if (lightmap_multi > 0 )
		{
            lightmapFactor = lightmapFactor * reflection_lighting;
	        lightmapcolor = lightmap_r_color * lightmapFactor.r +
                lightmap_g_color * lightmapFactor.g +
                lightmap_b_color * lightmapFactor.b +
                lightmap_a_color * lightmapFactor.a ;
            	}
	 else 
		{
                lightmapcolor = reflection_lighting.rgb * lightmap_r_color * lightmapFactor.r;
            	}

	}

float lightmap_intensity = length(lightmapcolor);
float light_fraction = clamp(lightmap_intensity / (length(light_diffuse.rgb) + 0.01), 0.0, 5.0);

if (light_fraction < 1.0) {light_fraction = smoothstep(0.7, 1.0, light_fraction);}


if (use_reflection ==1)
	{
	// to determine whether what we see reflected is currently in light, we make the somewhat drastic
	// assumption that its normal will be opposite to the glass normal
	// (which is mostly truish in a normal cockpit)
	float reflection_shade = ambient_fraction + (1.0-ambient_fraction) * max(0.0, dot (normalize(normal),  normalize(gl_LightSource[0].position.xyz)));

	texel.rgb = mix(texel.rgb, reflection.rgb, (reflection_strength *  reflection_shade  * (1.0-Mie)));

	}

//texel.rgb = mix(texel.rgb, lightmapcolor.rgb, lightmap_intensity);

// overlay pattern

if ((use_mask == 1) && (use_overlay==1))
	{
	vec4 overlay_texel = vec4(overlay_color, overlay_alpha);
	overlay_texel.rgb *=  light_diffuse.rgb* (1.0 + (1.0 + overlay_glare)*Mie);
	overlay_texel.a *=(1.0 + overlay_glare* Mie);
	texel = mix(texel, overlay_texel, func_texel.b * overlay_texel.a);
	}


// frost

float fth = (1.0-frost_level) * 0.4 + 0.3;
float fbl = 0.2 * frost_level;
 

float frost_factor =  (fbl + (1.0-fbl)* smoothstep(fth,fth+0.2,noise_003m)) * (4.0 + 4.0* Mie);


float background_frost =  0.5 * smoothstep(0.7,1.0,frost_level);
frost_texel.rgb = mix(frost_texel.rgb, vec3 (0.5,0.5,0.5), (1.0- smoothstep(0.0,0.02,frost_texel.a)));
frost_texel.a =max(frost_texel.a, background_frost * (1.0- smoothstep(0.0,0.02,frost_texel.a)));

frost_texel *=  vec4(light_diffuse.rgb,0.5) * (1.0 + 3.0 * Mie);

frost_factor = max(frost_factor, 0.8*background_frost);


texel.rgb =  mix(texel.rgb, frost_texel.rgb, frost_texel.a * frost_factor * smoothstep(0.0,0.1,frost_level));
texel.a = max(texel.a, frost_texel.a * frost_level);

// rain splashes

vec3 splash_vec = vec3 (splash_x, splash_y, splash_z);
float splash_speed = length(splash_vec);


float rain_factor = 0.0;

float rnorm = max(rain_norm, ground_splash_norm);

if (rnorm > 0.0)
	{
	float droplet_size = (0.5 + 0.8 * rnorm) * (1.0 - 0.1 * splash_speed);
	vec2 rainPos = vec2 (rawPos.x * splash_speed, rawPos.y / splash_speed );
	rainPos.y = rainPos.y - 0.1 * smoothstep(1.0,2.0, splash_speed) * osg_SimulationTime;
	if (splash_angle> 0.0)
	{	
	// the dynamically impacting raindrops
	float time_shape = 1.0;
	float base_rate = 6.0 + 3.0 * rnorm + 4.0 * (splash_speed - 1.0);
	float base_density = 0.6 * rnorm + 0.4  * (splash_speed -1.0);
    if ((use_mask == 1) && (use_wipers == 1)) {
        if (dualWipers) {
            base_density *= (1.0 - wipe);      // new behavior
        } else {
            base_density *= (1.0 - 0.5 * baseMask);  // old behavior
        }
    }

	float time_fact1 = (sin(base_rate*osg_SimulationTime));
	float time_fact2 = (sin(base_rate*osg_SimulationTime + 1.570));
	float time_fact3 = (sin(base_rate*osg_SimulationTime + 3.1415));
	float time_fact4 = (sin(base_rate*osg_SimulationTime + 4.712));

	time_fact1 = smoothstep(0.0,1.0, time_fact1);
	time_fact2 = smoothstep(0.0,1.0, time_fact2);
	time_fact3 = smoothstep(0.0,1.0, time_fact3);
	time_fact4 = smoothstep(0.0,1.0, time_fact4);

    	rain_factor += DotNoise2D(rawPos.xy, 0.02 * droplet_size ,0.5, base_density ) * time_fact1;
    	rain_factor += DotNoise2D(rainPos.xy, 0.03 * droplet_size,0.4, base_density) * time_fact2;
    	rain_factor += DotNoise2D(rawPos.xy, 0.04 * droplet_size ,0.3, base_density)* time_fact3;
    	rain_factor += DotNoise2D(rainPos.xy, 0.05 * droplet_size ,0.25, base_density)* time_fact4;
	}


	// the static pattern of small droplets created by the splashes

	float sweep = min(1./splash_speed,1.0);
    if ((use_mask == 1) && (use_wipers == 1)) {
        if (dualWipers) {
            sweep = mix(sweep, 0.0, wipe);        // wipe already shaped
        } else {
            // old static mask behavior
            sweep *= (1.0 - func_texel.g);
        }
    }
    float persistence = 0.7;           // 0 = instant, 1 = very slow
    sweep = pow(sweep, 1.0 + 3.0*persistence);

	if (adaptive_mapping ==2) {rainPos = nPos;}
	rain_factor += DropletNoise2D(rainPos.xy, 0.02 * droplet_size ,0.5, 0.6* rnorm * sweep);
	rain_factor += DotNoise2D(rainPos.xy, 0.012 * droplet_size ,0.7, 0.6* rnorm * sweep);
	}

rain_factor = smoothstep(0.1,0.2, rain_factor) * (1.0 - smoothstep(0.4,1.0, rain_factor) * (0.2+0.8*noise_0003m));


vec4 rainColor = vec4 (0.2,0.2, 0.2, 0.6 - 0.3 * smoothstep(1.0,2.0, splash_speed));
rainColor.rgb *= length(light_diffuse)/1.73;



// glass tint


vec4 outerColor = mix(texel, rainColor, rain_factor);
// now mix illuminated reflections in

vec3 reflLitColor = reflection.rgb * lightmapcolor.rgb;

outerColor.rgb = mix(outerColor.rgb, reflLitColor, clamp(reflection_strength * light_fraction,0.0,1.0));
outerColor.a = max(outerColor.a, 0.1 * light_fraction * reflection_strength);

outerColor  *= tint;




// fogging - this is inside the glass

vec4 fog_texel = vec4 (0.6,0.6,0.6, fog_level);

if (use_mask == 1) {fog_texel.a = fog_texel.a * func_texel.r;}

fog_texel *= vec4(light_diffuse.rgb,1.0); 
fog_texel.rgb *= (1.0 + 3.0 * Mie);
fog_texel.a *= min((1.0 + 0.5 * Mie), 0.85);


vec4 fragColor;

fragColor.rgb = mix(outerColor.rgb, fog_texel.rgb, fog_texel.a);
fragColor.a = max(outerColor.a, fog_texel.a);

fragColor.rgb = filter_combined(fragColor.rgb);

gl_FragColor = clamp(fragColor,0.0,1.0);


}
