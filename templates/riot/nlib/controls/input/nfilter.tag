<nfilter>
    <div class="input-container">
        <span ref="input" class="input" value={ opts.value } contenteditable></span>
        <div ref="clear" class="clear"><span class="fas fa-times"></span></div>
        <label>{ opts.title }</label>
    </div>
    <style>
        :scope {
            position: relative;
            display: grid;
            margin: 0 auto;
            padding: 0;
            grid-template-columns: 3px 1fr 3px;
            grid-template-rows: 3px auto 3px;
            grid-template-areas: 
                '. . .'
                '. input-ares .'
                '. . .';
            height: auto;
            width: 100%;
            background: transparent;
        }
        :scope>.input-container {
            grid-area: input-ares;
            position: relative;
            display: grid;
            grid-template-columns: 2px 5px 1fr 5px 20px 2px;
            grid-template-rows: 5px 1.7rem auto 5px;
            grid-template-areas: 
                '. . .  . . .'
                '. . .  . . .'
                '. . ctrl . clear .'
                '. . .  . . .';
            margin: 0;
            padding: 0;
            height: auto;
            width: 100%;
            /*
            box-shadow: 0 5px 10px rgba(0, 0, 0, .2);
            */
        }
        :scope>.input-container>.input {
            grid-area: ctrl;
            display: inline-block;
            margin: 0;
            padding: 0 5px;
            padding-bottom: 5px;
            width: 100%;
            /*
            background-color: whitesmoke;
            */
            background-color: transparent;
            box-sizing: border-box;
            box-shadow: none;
            outline: none;
            border: none;
            box-shadow: 0 0 0px 1000px white inset;
            border-bottom: 2px solid #999;
        }
        :scope>.input-container>.clear {
            grid-area: clear;
            display: flex;
            margin: 0 auto;
            margin-top: 4px;
            padding: 0px 3px;
            align-items: center;
            justify-items: center;
            font-weight: bold;
            font-size: .7rem;
            width: 18px;
            height: 18px;
            color: silver;
            cursor: pointer;
            user-select: none;
        }
        :scope>.input-container>.clear:hover {
            color: red;
        }
        :scope>.input-container>.clear:hover {
            color: red;
        }
        /* Change Autocomplete styles in Chrome*/
        :scope>.input-container>.input:-webkit-autofill,
        :scope>.input-container>.input:-webkit-autofill:hover, 
        :scope>.input-container>.input:-webkit-autofill:focus {
            transition: background-color 5000s ease-in-out 0s;
        }
        :scope>.input-container>label {
            position: absolute;
            top: 2rem;
            left: 14px;
            color: #555;
            transition: .2s;
            pointer-events: none;
        }
        :scope>.input-container>.input:focus ~ label {
            top: .25rem;
            left: 10px;
            color: #f7497d;
            font-weight: bold;
        }
        :scope>.input-container>.input:-webkit-autofill ~ label,
        :scope>.input-container>.input:valid ~ label {
            top: .25rem;
            left: 10px;
            color: cornflowerblue;
            font-weight: bold;
        }
        :scope>.input-container>.input:focus {
            background-color: #999;
            border-bottom: 2px solid #f7497d;
        }
        :scope>.input-container>.input:valid {
            border-bottom: 2px solid cornflowerblue;
        }
    </style>
    <script>
    </script>
</nfilter>