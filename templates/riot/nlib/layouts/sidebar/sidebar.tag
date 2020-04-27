<sidebar>
    <div class="sidebar-container">
        <yield/>
    </div>
    <style>
        :scope {
            position: relative;
            display: grid;
            grid-template-columns: auto;
            grid-template-rows: 1fr;
            grid-template-areas: 
                'sidebar-area';
            margin: 0;
            padding: 0;
            width: var(--sidebar-width);
            height: 100%;
            /* border: 1px solid silver; */
            z-index: 99999;
            overflow: hidden;
        } 
        :scope:empty {
            display: none;
        }
        :scope>.sidebar-container {
            grid-area: sidebar-area;
            position: relative;
            display: block;
            margin: 0 auto;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
        }
        @media only screen and (max-width: 600px) {
            /* Extra small devices (phones, 600px and down use max-width) */
        }
        @media only screen and (min-width: 600px) {
            /* Small devices (portrait tablets and large phones, 600px and up use min-width) */
        }
        @media only screen and (min-width: 992px) {
            /* Large devices (laptops/desktops, 992px and up) */
        }
        @media only screen and (min-width: 1200px) {
            /* Extra large devices (large laptops and desktops, 1200px and up) */
        }
    </style>
    <script>
        let self = this

        this.on('mount', () => {});
        this.on('unmount', () => {});
    </script>
</sidebar>