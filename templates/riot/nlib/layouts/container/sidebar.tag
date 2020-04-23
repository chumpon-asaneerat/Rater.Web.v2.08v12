<sidebar>
    <yield/>
    <style>
        :scope {
            display: inline-block;
            margin: 0;
            /*
            width: 300px;
            height: calc(100% - 3px);
            */
            background-color: burlywood;
            border: 1px solid black;
        }
    </style>
    <script>
        let self = this
        let addEvt = events.doc.add, delEvt = events.doc.remove
    </script>
</sidebar>