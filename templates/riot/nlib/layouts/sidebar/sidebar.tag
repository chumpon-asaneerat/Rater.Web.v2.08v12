<sidebar>
    <div class="sidebar-container">
        <yield/>
    </div>    
    <style>
        :scope {
            position: relative;
            display: none;
            margin: 0;
            padding: 0;
            width: 300px;
            height: calc(100% - 3px);
            border: 1px solid black;
            z-index: 99999;
            overflow: hidden;
        }        
        :scope.show, :scope.active {
            display: inline-block;
            position: fixed;
        }
        @media only screen and (max-width: 700px) {
            :scope.show, :scope.active {
                display: inline-block;
                position: absolute;
            }
        }
        :scope .sidebar-container {
            position: absolute;
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
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
            // test show..
            self.show();
        });
        this.on('unmount', () => {
            delEvt(events.name.SidebarStateChanged, onSidebarStateChanged)
            //freeCtrls()
        });

        let onSidebarStateChanged = () => {
            (sidebar.shown) ? self.show() : self.hide()
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