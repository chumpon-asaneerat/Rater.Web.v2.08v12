<sidebar>
    <div class="sidebar-area">
        <yield/>
    </div>    
    <style>
        :scope {
            position: relative;
            display: none;
            margin: 0;
            padding: 0;
            /* width: fit-content; */
            height: 100%;
            border: 1px solid silver;
            z-index: 99999;
            /* overflow: hidden; */
        }        
        :scope.show, :scope.active {
            display: block;
            position: relative;
        }
        :scope.pin.show, :scope.pin.active {
            position: relative;
        }
        :scope>.sidebar-area {
            position: relative;
            display: block;
            margin: 0 auto;
            padding: 0;
            width: var(--sidebar-width);
            height: 100%;
            overflow: auto;
        }
        :scope>.sidebar-area:empty {
            display: none;
        }
        @media only screen and (max-width: 600px) {
            /* Extra small devices (phones, 600px and down use max-width) */
            :scope.show, :scope.active {
                position: absolute;
                display: block;
                background-color: skyblue;
            }
        }
        @media only screen and (min-width: 600px) {
            /* Small devices (portrait tablets and large phones, 600px and up use min-width) */
            :scope.show, :scope.active {
                position: absolute;
                display: block;
                background-color: aquamarine;
            }
            :scope>.sidebar-area {
                width: var(--sidebar-collapse-width);
            }
            :scope>.sidebar-area:hover {
                width: var(--sidebar-width);
            }
        }
        @media only screen and (min-width: 992px) {
            /* Large devices (laptops/desktops, 992px and up) */
            :scope.show, :scope.active {
                position: absolute;
                display: block;
                background-color: antiquewhite;
            }
            :scope>.sidebar-area {
                width: var(--sidebar-width);
            }
        }
        @media only screen and (min-width: 1200px) {
            /* Extra large devices (large laptops and desktops, 1200px and up) */
        }
        :scope.c1 {
            background-color: burlywood;
        }
        :scope.c2 {
            background-color: aliceblue;
        }
        :scope.c3 {
            background-color: cornsilk;
        }
    </style>
    <script>
        let self = this
        let addEvt = events.doc.add, delEvt = events.doc.remove

        this.on('mount', () => {
            //initCtrls()
            addEvt(events.name.SidebarStateChanged, onSidebarStateChanged)

//================================= 
//======= test show begin..
//=================================
            
            //self.pin()
            self.show()

//=================================
//======= test show end..
//=================================
        });
        this.on('unmount', () => {
            delEvt(events.name.SidebarStateChanged, onSidebarStateChanged)
            //freeCtrls()
        });

        let onSidebarStateChanged = () => {
            (sidebar.shown) ? self.show() : self.hide()
        }

        this.pin = () => {
            self.root.classList.add('pin')
        }
        this.unpin = () => {
            self.root.classList.add('pin')
        }
        this.show = () => {
            console.log('show')
            self.root.classList.add('show')
        }
        this.hide = () => {
            console.log('hide')
            self.root.classList.remove('show')
        }
    </script>
</sidebar>