<sidebar-menu>
    <div class="menu">
        <a class="link-combo" href="javascript:;" onclick="{ toggle }">
            <span class="burger fas fa-bars"></span>
        </a>
    </div>
    <style>
        :scope {
            display: inline-block;
            margin: 0 auto;
            padding: 0, 2px;
            user-select: none;
        }
        :scope .menu {
            display: none;
        }
        @media only screen and (max-width: 600px) {
            /* Extra small devices (phones, 600px and down use max-width) */
            :scope .menu {
                display: inline-block;
            }
        }
        :scope .menu>a {
            margin: 0 auto;
            color: whitesmoke;            
        }
        :scope .menu>a:link, :scope .menu>a:visited { text-decoration: none; }
        :scope .menu>a:hover, :scope .menu>a:active {
            color: yellow;
            text-decoration: none;
        }
    </style>
    <script>
        let self = this;
        let addEvt = events.doc.add, delEvt = events.doc.remove

        this.on('mount', () => {
            //initCtrls()
            //bindEvents()
        });
        this.on('unmount', () => {
            //unbindEvents()
            //freeCtrls()
        });

        this.toggle = (e) => {
            e.preventDefault()
            e.stopPropagation()
            let navibar = self.parent
            let app = navibar.parent
        }
    </script>
</sidebar-menu>