<tabpage>
    <div class="tab-content-wrapper">
        <div class="tab-content-area">
            <yield />
        </div>
    </div>    
    <style>
        :scope {
            position: relative;
            display: none;
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            /* overflow: auto; */
            overflow: hidden;
            /* Fading effect takes 2 second */
            animation: fadeEffect 2s;
        }
        /* Go from zero to full opacity */     
        @keyframes fadeEffect {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        :scope.active { 
            display: block;
        }
        :scope>.tab-content-wrapper {
            position: absolute;
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
        }
        :scope>.tab-content-wrapper>.tab-content-area {
            position: relative;
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
        }
    </style>
    <script>
        let self = this;

        this.getTabName = () => {
            let ret = self.root.getAttribute('name').toLowerCase().trim()
            return ret
        }
        this.show = () => { self.root.classList.add('active') }
        this.hide = () => { self.root.classList.remove('active') }
    </script>
</tabpage>
