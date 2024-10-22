# Contributing Guidelines

These examples will show the guidelines for contributing. Please try to follow this at all times, or we may not merge your contribution.

## Basic Guidelines:
- ALWAYS use IntegratedSystems.
- DO NOT USE setprop/getprop unless its only done once! Use props.nas and Property Tree Setup.
- Use tabs to indent code, DO NOT USE SPACE.
- Use lowerCamelCase for naming Nasal variables/functions (someFunction).
- Use UpperCamelCase to name Nasal classes (SomeClass). All uppercase for root classes is permitted.
- Use comments when necessary, but no need to comment simple things.
- Do not add a comment to every line, only to functions/groups of code.
- Remove .bak or .blend files, unless absolutely needed.
- Leave one extra line at the bottom of each file.

## Formatting Guidelines:
Capitalization, Indenting, and Line Breaks:
```
<!-- XML -->
<something>
	<something-else>0</something-else>
	<something-more>
		<more-stuff>string</more-stuff>
	</something-more>
</something>
```

```
# Nasal
var something = func() {
	somethingElse();
}

var MyClass = { # Notice how it is alphabetized, except that methods are always last
	myVariable: 0,
	SubClass: {
		someVariable: 0,
	},
	myFunction: func() {
		me.myVariable = 1;
	},
	someFunction: func() {
		me.SubClass.someVariable = 1;
	},
};
```
Brackets, Spaces, Commas, Semi-Colons, and Parentheses:
```
var something = 0;
var someOtherThing = func() {
	if (something == 1) {
		something = 0;
	} else {
		something = 1;
	}
	
	settimer(func {
		props.globals.getNode("/something").setValue(something);
	}, 5);
}
```

## Forks, Branches, and Merging
Please fork the repository and commit your changes there. Branches are optional. When you are ready for us to look over your work, submit a pull request following our pull request template, and we will look over it. If there is an issue that needs to be resolved before merging, then we will leave a comment on the pull request.
