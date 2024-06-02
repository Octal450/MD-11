// Code inspired by: https://github.com/legoboyvdlp/A320-family/blob/dev/WebPanel/js/mcdu.js

const MCDU = (() => {
    screenshot_mcdu1 = "/screenshot?canvasindex=8&type=jpg";
    refresh_cooldown = 500;

    function init()
    {
		document.body.dataset.lastTouch = 0;
		document.body.addEventListener('touchstart', preventZoomAction, { passive: false });
        console.info("MCDU INIT");

        registerMcduButtons();
		setInterval(refreshMcduImg, refresh_cooldown);
    }

    function getMcduUrl(baseUrl)
    {
        cacheDate = new Date().getTime();
        return new Promise((resolve, reject) => {
            const new_url = baseUrl + '&cacheBust=' + cacheDate;
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
        let err_msg = "Error loading MCDU image, try to refresh the page";

        console.error(err_msg);
        alert(err_msg);
    }

    function setMcduUrl(url)
    {
        document.getElementById("mcduimg").src = url;
    }

    function refreshMcduImg() 
    {
        getMcduUrl(screenshot_mcdu1)
         .then(setMcduUrl)
         .catch(mcduRefreshFail);        
    }

    function registerMcduButtons()
    {
        document.querySelectorAll('[data-buttoncode]').forEach((btnElem) => {
            const btnFunc = getMcduButtonFunction(btnElem);
            if(!(typeof btnFunc === `function`)) return;

            btnElem.addEventListener('click', btnFunc);
			btnElem.addEventListener('touchstart', preventZoomAction, true);
        });
        let btn = document.querySelector("[data-button=\"button:CLR\"]");
        if (btn) btn.addEventListener("contextmenu", function(e){
            e.preventDefault();
            sendButtonpress('button', 'LONGCLR');
        });
    }

    function getMcduButtonFunction(btnElem)
    {
        const btnActions = btnElem.getAttribute('data-buttoncode').split(':');
        if (btnActions == "") return;
        const actionKey = btnActions[0];
        const actionValue = btnActions[1];

        if(!actionKey)
        {
            return;
        }

        return function()
        {
            sendButtonpress(actionKey, actionValue);
        }
    }

    function sendButtonpress(type, text)
    {
        let req = new XMLHttpRequest;
        req.open("POST", "/run.cgi?value=nasal");
        req.setRequestHeader("Content-Type", "application/json");
        let body = JSON.stringify({
            "name": "",
            "children": [
                {
                    "name": "script",
                    "index": 0,
                    "value": "mcdu.unit[0]." + type + "(\"" + text + "\");"
                }
            ]
        });
        req.send(body);
        return new Promise((resolve) => {
            req.addEventListener('load', () => {
                refreshMcduImg();
                resolve();
            }, true);
        });
    }

    //https://exceptionshub.com/disable-double-tap-zoom-option-in-browser-on-touch-devices.html
	function preventZoomAction(event) {
		const t2 = event.timeStamp;
		const touchedElement = event.currentTarget;
		const t1 = touchedElement.dataset.lastTouch || t2;
		const dt = t2 - t1;
		const fingers = event.touches.length;
		touchedElement.dataset.lastTouch = t2;

		if (!dt || dt > 500 || fingers > 1) {
			// no double-tap
			return;
		}

		event.preventDefault();
		event.target.click();
	}

    init();
})();