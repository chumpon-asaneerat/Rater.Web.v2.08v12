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
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
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