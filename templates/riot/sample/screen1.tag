<screen1>
    <yield/>
    <button onclick="{ gotoScreen2 }">Goto Screen 2</button>
    <style>
        :scope {
            margin: 0 auto;
            padding: 0;
            width: 100%;
            height: 100%;
        }
    </style>
    <script>
        let self = this
        let scrId = 'screen1'

        this.gotoScreen2 = (e) => { screens.show('screen2') }
    </script>
</screen1>
