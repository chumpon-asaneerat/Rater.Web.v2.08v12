<screen1>
    <sidebar class="c1">
        <h6>Sidebar 1</h6>
    </sidebar>
    <sidebar class="c2">
        <h6>Sidebar 2</h6>
    </sidebar>
    <sidebar class="c3">
        <h6>Sidebar 3</h6>
    </sidebar>
    <h4>Screen 1</h4>
    <button onclick="{ gotoScreen2 }">Goto Screen 2</button>
    <sidebar class="c1">
        <h6>Sidebar 4</h6>
    </sidebar>
    <sidebar class="c2">
        <h6>Sidebar 5</h6>
    </sidebar>
    <sidebar class="c3">
        <h6>Sidebar 6</h6>
    </sidebar>
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
