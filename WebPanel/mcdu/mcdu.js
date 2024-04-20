// Code inspired by: https://github.com/legoboyvdlp/A320-family/blob/dev/WebPanel/js/mcdu.js

const MCDU = (() => {
    screenshot_mcdu1 = "/screenshot?canvasindex=8&type=jpg";
    refresh_cooldown = 500;

    function init()
    {
        console.info("MCDU INIT");

        // H
		setInterval(refreshMcduImg, refresh_cooldown);
    }

    function getMcduUrl(baseUrl)
    {
        cacheDate = new Date().getTime();
        return new Promise((resolve, reject) => {
            const new_url = screenshot_mcdu1 + '&cacheBust=' + cacheDate;
            const check_img = new Image;

            check_img.addEventListener('error', reject);

            check_img.addEventListener('load', (event) => {
                resolve(new_url);
            });
            check_img.src = new_url;
        });
    }

    function mcduRefreshFail()
    {
        let err_msg = "Loading MCDU image, try refresh page";

        console.error(err_msg);
        alert(err_msg);
    }

    function setMcduUrl(url)
    {
        document.getElementById("mcduimg").src = url;
    }

    function refreshMcduImg() 
    {
        getMcduUrl()
         .then(setMcduUrl)
         .catch(mcduRefreshFail);        
    }

    init();
})();