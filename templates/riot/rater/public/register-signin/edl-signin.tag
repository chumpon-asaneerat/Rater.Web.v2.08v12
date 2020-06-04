<edl-signin>
    <div class="content-area">
        <div class="input-area">
            <div class="input-group">
                <ninput ref="username" type="email" title="User Name"></ninput>
                <ninput ref="password" type="password" title="Password"></ninput>
            </div>
        </div>
        <div class="button-area">
            <div class="button-group">
                <button ref="submit">
                    <span class="fas fa-user">&nbsp;</span>
                    Sign In
                </button>
            </div>
        </div>
    </div>
    <style>
        :scope {
            margin: 0 auto;
            padding: 0;
            position: relative;
            width: 100%;
            height: 100%;
            display: grid;
            grid-template-columns: 1fr;
            grid-template-rows: 1fr;
            grid-template-areas: 
                'content-area';
            overflow: hidden;
        }
        :scope>.content-area {
            grid-area: content-area;
            position: relative;
            display: grid;
            grid-template-columns: 1fr;
            grid-template-rows: 25px 250px 50px 1fr;
            grid-template-areas: 
                '.'
                'input-area'
                'button-area'
                '.';
            width: 100%;
            overflow: hidden;
        }
        :scope>.content-area>.input-area {
            grid-area: input-area;
            position: relative;
            display: flex;
            margin: 0 auto;
            padding: 0;
            align-items: center;
            justify-content: center;
            width: 100%;
        }
        :scope>.content-area>.input-area>.input-group {
            position: relative;
            display: block;
            margin: 0 auto;
            padding: 0;
            width: 400px;
        }
        :scope>.content-area>.input-area>.input-group ninput {
            position: relative;
            display: block;
            margin: 0 auto;
            padding: 0;
            width: 100%;
        }
        :scope>.content-area>.button-area {
            grid-area: button-area;
            position: relative;
            display: flex;
            margin: 0 auto;
            padding: 0;
            align-items: center;
            justify-content: center;
            width: 100%;
        }
        :scope>.content-area>.button-area>.button-group {
            position: relative;
            display: block;
            margin: 0 auto;
            padding: 0;
            width: 400px;
        }
        :scope>.content-area>.button-area>.button-group button {
            position: relative;
            display: inline-block;
            /*
            margin: 0 auto;
            padding: 0;
            width: 100%;
            */
            display: block;
            margin: 5px auto;
            padding: 10px 15px;

            color: whitesmoke;
            background-color: forestgreen;

            font-weight: bold;
            cursor: pointer;
            width: 45%;
            text-decoration: none;
            /* vertical-align: middle; */
        }
        :scope>.content-area>.button-area>.button-group button:hover {
            background-color: darkgreen;
        }
    </style>
    <script>
        // for edl's device signin
    </script>
</edl-signin>