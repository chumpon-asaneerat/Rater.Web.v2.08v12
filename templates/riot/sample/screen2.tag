<screen2>
    <h3>Screen 2</h3>
    <button onclick="{ gotoScreen1 }">Goto Screen 1</button>
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
        let scrId = 'screen2'

        this.gotoScreen1 = (e) => { screens.show('screen1') }
    </script>
</screen2>
