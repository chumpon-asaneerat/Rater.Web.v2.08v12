<company-selection>
    <virtual each={ user in users }>
        <div class="account">
            <div class="info1">
                <span class="label">{ opts.companyname }</span>
                <span class="data">{ user.CustomerName }</span>                
            </div>
            <div class="info2">
                <span class="label">{ opts.fullname }</span>
                <span class="data">{ user.FullName }</span>                
            </div>
            <button onclick="{ onSignIn }">&nbsp;<span class="fas fa-2x fa-sign-in-alt">&nbsp;</span></button>
        </div>
        <hr>
    </virtual>
    <style>
        :scope {
            display: block;
            margin: 0 auto;
            padding: 0;
        }
        :scope .account {
            margin: 0 auto;
            padding: 2px;
            height: 100%;
            width: 100%;
            display: grid;
            grid-template-columns: 1fr 1fr;
            grid-template-rows: 1fr 1fr;
            grid-template-areas: 
                'info1 button'
                'info2 button';
            overflow: hidden;
            overflow-y: auto;
        }
        :scope .account div {
            display: block;
            margin: 0 auto;
            padding: 0;
        }
        :scope .account div.info1 {
            grid-area: info1;
            display: block;
            margin: 0;
            padding: 0;
            padding-left: 20px;
        }
        :scope .account div.info2 {
            grid-area: info2;
            display: block;
            margin: 0;
            padding: 0;
            padding-left: 20px;
        }
        :scope .account div.info1 span,
        :scope .account div.info2 span {
            display: inline-block;
            margin: 0;
            padding: 0;
        }
        :scope .account div.info1 span.label,
        :scope .account div.info2 span.label {
            display: inline-block;
            margin: 0 auto;
            padding: 0;
            font-weight: bold;
            color: navy;
            width: 100%;
        }
        :scope .account div.info1 span.data,
        :scope .account div.info2 span.data {
            display: inline-block;
            margin: 0 auto;
            padding: 0;
            font-weight: bold;
            color: forestgreen;
            width: 100%;
        }
        :scope .account button {
            grid-area: button;
            display: inline-block;
            margin: 0 auto;
            padding: 0;
            font-weight: bold;
            color: forestgreen;
            width: 100%;
        }
    </style>
    <script>
        let self = this
        this.users = []

        let addEvt = events.doc.add, delEvt = events.doc.remove
        this.on('mount', () => {
            bindEvents()
        })
        this.on('unmount', () => {
            unbindEvents()
        });
        let bindEvents = () => {
            addEvt(events.name.LanguageChanged, onLanguageChanged)
            addEvt(events.name.ContentChanged, onContentChanged)
            addEvt(events.name.UserListChanged, onUserListChanged)
        }
        let unbindEvents = () => {
            delEvt(events.name.UserListChanged, onUserListChanged)
            delEvt(events.name.ContentChanged, onContentChanged)
            delEvt(events.name.LanguageChanged, onLanguageChanged)
        }
        let onContentChanged = (e) => { updatecontent() }
        let onLanguageChanged = (e) => { updatecontent() }
        let onUserListChanged = (e) => { updatecontent() }

        let updatecontent = () => {
            if (secure) {
                //console.log(secure)
                self.users = (secure.content) ? secure.users : []
                self.update()
            }
        }

        this.onSignIn = (e) => {
            let acc = e.item.user
            secure.signin(acc.customerId)
        }
    </script>
</company-selection>