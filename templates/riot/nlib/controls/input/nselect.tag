<nselect>
    <div class="input-container">
        <select ref="input">
            <option each={ item in items } value="{ item.value }">{ item.text }</option>
        </select>
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
        :scope>.input-container>select {
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
        /* Change Autocomplete styles in Chrome*/
        :scope>.input-container>select:-webkit-autofill,
        :scope>.input-container>select:-webkit-autofill:hover, 
        :scope>.input-container>select:-webkit-autofill:focus {
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
        :scope>.input-container>select:focus ~ label {
            top: .25rem;
            left: 10px;
            color: #f7497d;
            font-weight: bold;
        }
        :scope>.input-container>select:-webkit-autofill ~ label,
        :scope>.input-container>select:valid ~ label {
            top: .25rem;
            left: 10px;
            color: cornflowerblue;
            font-weight: bold;
        }
        :scope>.input-container>select:focus {
            border-bottom: 2px solid #f7497d;
        }
        :scope>.input-container>select:valid {
            border-bottom: 2px solid cornflowerblue;
        }
    </style>
    <script>
        let self = this
        let fldmap = { valueField:'code', textField:'name' }
        let defaultItem = { 
            value: '', 
            text: '-', 
            source: null 
        }
        this.items = []
        this.items.push(defaultItem)

        this.on('mount', () => {
            initCtrls()
            bindEvents()
        })
        this.on('unmount', () => {
            unbindEvents()
            clearInputs()
        })

        let input, clear
        let initCtrls = () => {
            input = self.refs['input']
            clear = self.refs['clear']
            disableFirstOption();
        }
        let freeCtrls = () => {
            input = null;
            clear = null;
        }
        let clearInputs = () => {
            if (input) {
                input.selectedIndex = 0
                if (onChangeCallback) onChangeCallback()
            }
        }
        let disableFirstOption = () => {
            if (input && input.options[0]) {
                let opt = input.options[0]
                opt.setAttribute('disable', '')
                opt.setAttribute('selected', '')
                opt.style.display = 'none'
            }
        }
        let bindEvents = () => {
            input.addEventListener('change', onSelection)
            clear.addEventListener('click', onClear)
        }
        let unbindEvents = () => {
            clear.removeEventListener('click', onClear)
            input.removeEventListener('change', onSelection)
        }
        let onChangeCallback;
        let onClear = () => { clearInputs() }
        let onSelection = (e) => {
            if (input) {
                let idx = input.selectedIndex
                let val = input.options[input.selectedIndex].value
                //console.log('selected value:', val)
                if (onChangeCallback) onChangeCallback()
            }
        }
        this.clear = () => { clearInputs(); }
        this.focus = () => { if (input) input.focus(); }

        let hasValue = (val) => { return (val !== undefined && val !== null) }
        let getSelectedIndexByValue = (val) => {
            let sVal = val.toString()
            let opt, idx = 0
            for (let i = 0; i < input.options.length; i++) {
                opt = input.options[i]
                if (opt.value.toString() === sVal) { 
                    //console.log('found idx:', i)
                    idx = i
                    break
                }
            }
            return idx
        }
        let getSelectedValue = () => {
            let idx = input.selectedIndex
            let ret = (idx > 0) ? input.options[input.selectedIndex].value : null
            return ret
        }
        this.value = (val) => {
            let ret
            if (input) {
                if (hasValue(val)) {
                    input.selectedIndex = getSelectedIndexByValue(val)
                }
                else {
                    ret = getSelectedValue()
                }
            }
            return ret
        }
        this.selectedItem = () => {
            let ret
            if (input) {
                let idx = input.selectedIndex
                if (idx >= 0 && idx < self.items.length) {
                    ret = self.items[idx].source
                }
            }
            return ret
        }
        this.setup = (values, fldMap, callback) => {
            fldmap = fldMap
            onChangeCallback = callback
            self.items = [];
            self.items.push(defaultItem)
            values.forEach(val => {
                let item = {
                    value: val[fldmap.valueField],
                    text: val[fldmap.textField],
                    source: val
                }
                self.items.push(item)
            })
            disableFirstOption()
            self.update()
        }
    </script>
</nselect>