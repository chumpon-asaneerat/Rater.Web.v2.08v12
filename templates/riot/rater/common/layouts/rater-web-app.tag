<rater-web-app>
    <napp>
        <!--
        <sidebar ref="sidebar">
            <div>
                <h6>Sidebar Begin</h6>
                <div class="sample-block"></div>
                <h6>Block 1</h6>
                <div class="sample-block"></div>
                <h6>Block 2</h6>
                <div class="sample-block"></div>
                <h6>Block 3</h6>
                <div class="sample-block"></div>
                <h6>Block 4</h6>
                <div class="sample-block"></div>
                <h6>End of Sidebar</h6>
            </div>
        </sidebar>
        -->
        <navibar>
            <navi-item>
                <sidebar-menu></sidebar-menu>
            </navi-item>
            <navi-item>
                <div class="banner">
                    <!--
                    <div class="status responsive" mobile>1</div>&nbsp;&nbsp;
                    -->
                    <div class="caption responsive" mobile>My Choice Rater Web{ (content && content.title) ? '&nbsp;-&nbsp;' : '&nbsp;'}</div>
                    <div class="title responsive" tablet>{ (content && content.title) ? content.title : '' }</div>
                </div>
            </navi-item>
            <navi-item class="center"></navi-item>
            <navi-item class="right">
                <language-menu></language-menu>
            </navi-item>
            <navi-item class="right">
                <links-menu></links-menu>
            </navi-item>
        </navibar>
        <yield/>
        <statusbar>
            <span class="copyright">EDL Co., Ltd.</span>
        </statusbar>
    </napp>
    <style>
        :scope {
            position: relative;
            display: block;
            margin: 0;
            padding: 0;
            width: auto;
            height: auto;
            overflow: hidden;
        }
        .banner>.status {
            position: relative;
            display: none;
            margin: 0 auto;
            padding: 0;
            white-space: nowrap;
            overflow: hidden;
            text-align: center;
            text-overflow: ellipsis;
            font-size: 0.8rem;
            /* vertical alien setting */
            height: 0.8rem;
            line-height: 0.8rem;
            
            width: 1rem;
            color: white;
            background-color: forestgreen;
            border-radius: 50%;
        }
        .banner>.title {
            position: relative;
            display: none;
            margin: 0;
            padding: 0;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            font-size: 1.2rem;
            line-height: 1rem; /* override defauat line height */
        }
        .banner>.caption {
            position: relative;
            display: none;
            margin: 0;
            padding: 0;
            width: auto;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            font-size: 1.2rem;
            line-height: 1rem; /* override defauat line height */
        }
        @media only screen and (max-width: 600px) {
            /* Extra small devices (phones, 600px and down use max-width) */
            [class~="responsive"][phone] { display: inline-block; }
        }
        @media only screen and (min-width: 600px) {
            /* Small devices (portrait tablets and large phones, 600px and up use min-width) */
            [class~="responsive"][mobile] { display: inline-block; }
        }
        @media only screen and (min-width: 768px) {
            /* Medium devices (landscape tablets, 768px and up) */
            [class~="responsive"][tablet] { display: inline-block; }
        }
        @media only screen and (min-width: 992px) {
            /* Large devices (laptops/desktops, 992px and up) */
            [class~="responsive"][desktop] { display: inline-block; }
        }
        @media only screen and (min-width: 1200px) {
            /* Extra large devices (large laptops and desktops, 1200px and up) */
            [class~="responsive"][widescreen] { display: inline-block; }
        }
        language-menu {
            position: relative;
            display: flex;
            margin: 0 auto;
            padding: 0;
            align-items: center;
            justify-content: stretch;
        }
        links-menu {
            position: relative;
            display: flex;
            margin: 0 auto;
            padding: 0;
            align-items: center;
            justify-content: stretch;
        }
        .copyright {
            position: relative;
            margin: 0;
            padding: 0;
            font-size: .5em;
            color: black;            
        }
        .sample-block {
            position: relative;
            display: block;
            height: 250px;
        }
    </style>
    <script>
        //#region Internal Variables

        let self = this;
        this.content = {
            title: ''
        }
        this.hasContent = () => { return (this.content !== undefined && this.content != null) }

        //#endregion

        let sidebar;
        let updatecontent = () => {
            /*
            let scrId = screens.current.screenId;
            let scrContent = (contents.current && contents.current.screens) ? contents.current.screens[scrId] : null;
            self.content = scrContent ? scrContent : { title: '' };
            */
            self.update()
        }

        let addEvt = events.doc.add, delEvt = events.doc.remove

        this.on('mount', () => {
            bindEvents()
            sidebar = self.tags['napp'].refs['sidebar']
            //if (sidebar) sidebar.pin()
        })
        this.on('unmount', () => {
            unbindEvents()
        })

        let bindEvents = () => {
            addEvt(events.name.LanguageChanged, onLanguageChanged)
            //addEvt(events.name.ContentChanged, onContentChanged)
            addEvt(events.name.ScreenChanged, onScreenChanged)
        }
        let unbindEvents = () => {
            delEvt(events.name.ScreenChanged, onScreenChanged)
            //delEvt(events.name.ContentChanged, onContentChanged)
            delEvt(events.name.LanguageChanged, onLanguageChanged)
        }

        let onContentChanged = (e) => { updatecontent() }
        let onLanguageChanged = (e) => { updatecontent() }
        let onScreenChanged = (e) => { updatecontent() }
    </script>
</rater-web-app>