<sidebar>
    <yield/>
    <style>
        :scope {
            position: fixed;
            display: none;
            margin: 0;
            padding: 0;
            width: 300px;
            height: calc(100% - 3px);
            /*
            width: 300px;
            height: calc(100% - 3px);
            */
            border: 1px solid black;
            z-index: 99999;
        }        
        :scope.show, :scope.active {
            display: inline-block;
            position: fixed;
        }
        @media only screen and (max-width: 700px) {
            :scope.show, :scope.active {
                display: inline-block;
                position: fixed;
            }
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