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
            width: 100%;
            height: 100%;
            /* border: 1px solid silver; */
            z-index: var(--sidebar-zindex);
            overflow: hidden;
        }
        :scope.pin {
            overflow: hidden;
        }
        /* Check has child declare in tag */
        :scope:empty {
            display: none;
        }
        /* Normal mode */
        :scope>.sidebar-container {
            grid-area: sidebar-area;
            position: relative;
            display: block;
            margin: 0 auto;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
        }
        :scope.pin>.sidebar-container {
            overflow: auto;
        }
        @media only screen and (max-width: 600px) {
            /* Extra small devices (phones, 600px and down use max-width) */
            :scope {
                /* small screen so hide it. */
                position: absolute;
                display: none;
                background-color: burlywood;
            }
        }
        @media only screen and (min-width: 600px) {
            /* Small devices (portrait tablets and large phones, 600px and up use min-width) */
            :scope {
                /* small screen so hide it. */
                position: absolute;
                display: none;
                background-color: burlywood;
            }
        }
        @media only screen and (min-width: 768px) {
            /* Medium devices (landscape tablets, 768px and up) */
            :scope {
                /* wide enough width so set to collapse mode so collapse it. */
                position: relative;
                display: block;
                width: var(--sidebar-collapse-width);
                background-color: azure;
                overflow: hidden;
            }
            :scope:hover,
            :scope.pin {
                /* hover or pin show full width */
                position: relative;
                display: block;
                width: var(--sidebar-width);
                background-color: azure;
                overflow: hidden;
            }
            :scope:hover>.sidebar-container,
            :scope.pin>.sidebar-container {
                /* also set container scrollbar */
                overflow: auto;
            }
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

        this.pin = () => {
            self.root.classList.add('pin')
        }
        this.unpin = () => {
            self.root.classList.remove('pin')
        }
    </script>
</sidebar>