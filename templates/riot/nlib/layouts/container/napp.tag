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
                'sidebar-area navi-area'
                'sidebar-area scrn-area'
                'sidebar-area stat-area';
            /*
            grid-template-areas: 
                'navi-area navi-area'
                'sidebar-area scrn-area'
                'sidebar-area stat-area';
            */
            /*
            grid-template-areas: 
                'navi-area navi-area'
                'sidebar-area scrn-area'
                'stat-area stat-area';
            */
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
        }
        /* ignore all child if not sidebar, navibar, screen, statusbar */
        :scope>.app-area>:not(sidebar):not(navibar):not(screen):not(statusbar) {
            display: none;
        }
        /* sidebar */
        :scope>.app-area sidebar {
            grid-area: sidebar-area;
            position: absolute;
        }
        /* sidebar - hide when empty or more than one */
        :scope>.app-area sidebar:nth-of-type(1):empty, 
        :scope>.app-area sidebar:not(:nth-of-type(1)) {
            display: none;
        }
        @media only screen and (max-width: 600px) {
            /* Extra small devices (phones, 600px and down use max-width) */
            :scope>.app-area sidebar {
                position: absolute;
            }
        }
        @media only screen and (min-width: 768px) {
            /* Medium devices (landscape tablets, 768px and up) */
            :scope>.app-area sidebar {
                position: relative;
            }
        }
        /* navibar (header main menu) */
        :scope>.app-area navibar {
            grid-area: navi-area;
            position: relative;
        }
        /* navibar - hide when empty hide when empty or more than one */
        :scope>.app-area navibar:nth-of-type(1):empty,
        :scope>.app-area navibar:not(:nth-of-type(1)) {
            display: none;
        }
        /* screen(s) */
        :scope>.app-area screen {
            grid-area: scrn-area;
            position: relative;
        }
        /* statusbar */
        :scope>.app-area statusbar {
            grid-area: stat-area;
            position: relative;
            line-height: 1rem; /* change browser default line height */
        }
        /* statusbar - hide when empty hide when empty or more than one */
        :scope>.app-area statusbar:nth-of-type(1):empty,
        :scope>.app-area statusbar:not(:nth-of-type(1)) {
            display: none;
        }
    </style>
</napp>