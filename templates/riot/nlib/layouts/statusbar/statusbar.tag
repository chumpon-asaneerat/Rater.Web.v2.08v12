<statusbar>
    <div class="statusbar-container">
        <yield />
    </div>
    <style>
        :scope {
            position: absolute;
            display: block;
            margin: 0;
            padding: 0;
            bottom: 0;
            width: 100%;
            user-select: none;
            white-space: nowrap;
            overflow: hidden;
        }
        :scope>.statusbar-container {
            position: relative;
            margin: 0;
            padding: 0;
            width: 100%;
        }
    </style>
    <script>
    </script>
</statusbar>