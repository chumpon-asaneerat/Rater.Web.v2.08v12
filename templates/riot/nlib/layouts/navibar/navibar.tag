<navibar>
    <yield/>
    <style>
        :scope {
            position: relative;
            display: flex;
            align-items: baseline;
            justify-content: space-between;
            margin: 0;
            padding: 1px 4px;
            width: 100%;
            color: var(--navibar-foreground-color);
            background-color: var(--navibar-background-color);
            overflow: hidden;
        }
        /* check navi item valid types */
        /*
        :scope>.app-area>:not(navi-item):not(navi-drop-item):not(navi-input-item) {
            display: none;
        }
        */
        /* test navi item child css detection */
        /*
        :scope:not(:first-child) { color: blue; }
        :scope:first-child { color: red; }
        */
    </style>
</navibar>