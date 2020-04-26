<napp>
    <div class="app-area">
        <yield/>
    </div>    
    <style>
        :scope {
            display: grid;
            margin: 0 auto;
            padding: 0;
            height: 100vh;
            width: 100vw;
            grid-template-areas: 
                'app-area';
            background: inherit;
            overflow: hidden;
        }
        :scope>.app-area {
            grid-area: app-area;
            position: relative;
            display: grid;
            grid-template-columns: auto 1fr;
            grid-template-rows: auto 1fr auto;
            grid-template-areas: 
                'navi-area navi-area'
                'sidebar-area scrn-area'
                'sidebar-area stat-area';
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
        }
        /* ignore all child if not sidebar or navibar or screen or statusbar (footer) */
        :scope>.app-area>:not(sidebar):not(navibar):not(screen):not(statusbar) {
            display: none;
        }
        /* sidebar */
        :scope>.app-area sidebar:nth-of-type(1) {
            grid-area: sidebar-area;
            position: relative;
            /* padding: 0 5px; */
            margin: 0;
            padding: 0;
        }
        :scope>.app-area sidebar:not(:nth-of-type(1)) {
            grid-area: sidebar-area;
            display: none;
            margin: 0;
            padding: 0;
        }
        /* navibar (header main menu) */
        :scope>.app-area navibar:nth-of-type(1) {
            grid-area: navi-area;
            position: relative;
            /* padding: 0 5px; */
            margin: 0;
            padding: 0;
        }
        :scope>.app-area navibar:not(:nth-of-type(1)) {
            grid-area: navi-area;
            display: none;
            margin: 0;
            padding: 0;
        }
        /* screen(s) */
        :scope>.app-area screen {
            grid-area: scrn-area;
            position: relative;
            /* padding: 5px; */
            margin: 0;
            padding: 0;
        }
        /* statusbar (footer) */
        :scope>.app-area statusbar:last-of-type(1) {
            grid-area: stat-area;
            position: relative;
            /* padding: 0 5px; */
            margin: 0;
            padding: 0;
        }
        :scope>.app-area statusbar:not(:last-of-type(1)) {
            grid-area: stat-area;
            display: none;
            margin: 0;
            padding: 0;
        }
    </style>
</napp>