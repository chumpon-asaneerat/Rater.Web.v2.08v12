<screen>
    <div class="content-area">
        <yield/>
    </div>
    <style>
        :scope {
            margin: 0 auto;
            padding: 0;
            display: none;
            width: 100%;
            height: 100%;
        }
        :scope.active,
        :scope.show { 
            display: grid;
            grid-template-columns: 1fr;
            grid-template-rows: 1fr;
            grid-template-areas: 
                'content-area';
        }
        :scope .content-area {
            grid-area: content-area;
            position: relative;
            display: grid;
            grid-template-columns: auto 1fr auto;
            grid-template-rows: 1fr;
            grid-template-areas: 
                'sidebar-left content-body sidebar-right';
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
        }
        :scope .content-area sidebar[position="left"] {
            grid-area: sidebar-left;
            margin: 0;
            padding: 0;
            top: 0;
            left: 0;
            bottom: 0;
            width: 300px;
            height: 100%;
        }
        :scope .content-area sidebar[position="right"] {
            grid-area: sidebar-right;
            margin: 0;
            padding: 0;
            top: 0;
            right: 0;
            bottom: 0;
            width: 300px;
            height: 100%;
        }
        :scope .content-area sidebar[position="left"][mode="float"] {
            grid-area: sidebar-left;
            position: absolute;
            width: 50px;
            background-color: aqua;
        }
        :scope .content-area sidebar[position="left"][mode="float"]:hover {
            width: 250px;
        }
        :scope .content-area .content-body {
            grid-area: content-body;
            margin: 0;
            padding: 0;
            height: 100%;
        }
    </style>
    <script>
        let self = this
        let addEvt = events.doc.add, delEvt = events.doc.remove
        this.on('mount', () => {
            addEvt(events.name.ScreenChanged, onScreenChanged)
        })
        this.on('unmount', () => {
            delEvt(events.name.ScreenChanged, onScreenChanged)
        })

        let onScreenChanged = (e) => {
            (screens.is(self.opts.screenid)) ? self.show() : self.hide()
            self.update()
        }
        
        this.hide = () => { self.root.classList.remove('show') }
        this.show = () => { self.root.classList.add('show') }
    </script>
</screen>