<ndialog>
    <!-- Modal content -->
    <div class="modal-content">
        <span ref="closeBtn" class="close">&times;</span>
        <div class="modal-content-area">
            <yield/>
        </div>
    </div>  
    <style>
        :scope {
            display: none; /* Hidden by default */
            position: fixed; /* Stay in place */
            z-index: 1; /* Sit on top */
            left: 0;
            top: 0;
            margin: 0;
            padding: 0;
            width: 100%; /* Full width */
            height: 100%; /* Full height */
            overflow: none; /* Enable scroll if needed */
            background-color: rgb(0,0,0); /* Fallback color */
            background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
        }
        /* Modal Content/Box */
        :scope .modal-content {
            position: relative;
            display: block;
            background-color: #fefefe;
            margin: 5% auto; /* 5% from the top and centered */
            padding: 10px;
            border: 1px solid #888;
            /* Could be more or less, depending on screen size */
            width: 80%; 
            height: 80%;
        }
        :scope .modal-content .modal-content-area {
            position: relative;
            display: block;
            margin: 0;
            padding: 5%;
            width: 100%; 
            height: 100%;
            overflow: hidden;
        }
        /* The Close Button */
        :scope .close {
            position: relative;
            float: right;
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            display: none; /* hide temp */
        }
        :scope .close:hover, :scope .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
    </style>
    <script>
        //#region Internal Variables

        let self = this;

        //#endregion

        //#region controls variables and methods

        let closeBtn;
        let initCtrls = () => {
            closeBtn = self.refs['closeBtn']
        }
        let freeCtrls = () => {
            closeBtn = null;
        }

        //#endregion

        //#region document listener add/remove handler

        let addEvt = (evtName, handle) => { document.addEventListener(evtName, handle) }
        let delEvt = (evtName, handle) => { document.removeEventListener(evtName, handle) }

        //#endregion

        //#region events bind/unbind

        let bindEvents = () => {
            //addEvt(events.name.ShowOsd, showOsd)
            //addEvt(events.name.UpdateOsd, updateOsd)
            //addEvt(events.name.HideOsd, hideOsd)
            window.addEventListener('click', windowClick)
            closeBtn.addEventListener('click', closeClick)
        }
        let unbindEvents = () => {
            closeBtn.removeEventListener('click', closeClick)
            window.removeEventListener('click', windowClick)
            //delEvt(events.name.HideOsd, hideOsd)
            //delEvt(events.name.UpdateOsd, updateOsd)
            //delEvt(events.name.ShowOsd, showOsd)
        }

        //#endregion

        //#region riot handlers

        this.on('mount', () => {
            initCtrls();
            bindEvents();
        });
        this.on('unmount', () => {
            unbindEvents();
            freeCtrls();
        });

        //#endregion

        let windowClick = (evt) => {
            // When the user clicks anywhere outside of the modal, close it
            if (evt.target === self.root) { 
                console.log('target:', evt.target)
                self.hide()
            }
        }
        let closeClick = (evt) => {
            self.hide()
        }
        this.show = () => {
            self.root.style.display = "block";
        }
        this.hide = () => {
            self.root.style.display = "none";
        }
    </script>
</ndialog>