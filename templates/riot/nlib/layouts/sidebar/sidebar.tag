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
            height: 100%;
            border: 1px solid silver;
            z-index: 99999;
            overflow: hidden;
        }        
        :scope.show, :scope.active {
            display: inline-block;
            position: absolute;
        }
        @media only screen and (max-width: 700px) {
            :scope.show, :scope.active {
                display: inline-block;
                position: absolute;
            }
        }
        :scope .sidebar-container {
            position: absolute;
            margin: 0 auto;
            /* padding: 5px; */
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

//================================= 
//======= test show begin..
//=================================
            
            self.show();

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