<staff-entry>
    <ninput ref="prefix" title="{ content.entry.prefix }" type="text" name="prefix"></ninput>
    <ninput ref="firstName" title="{ content.entry.firstName }" type="text" name="firstName"></ninput>
    <ninput ref="lastName" title="{ content.entry.lastName }" type="text" name="lastName"></ninput>
    <virtual if={ isDefault() }>
        <ninput ref="userName" title="{ content.entry.userName }" type="text" name="userName"></ninput>
        <ninput ref="passWord" title="{ content.entry.passWord }" type="password" name="passWord"></ninput>
        <!--
        <ninput ref="memberType" title="{ content.entry.memberType }" type="text" name="memberType"></ninput>
        -->
        <nselect ref="memberTypes" title="{ content.entry.memberType }"></nselect>
    </virtual>
    <style>
        :scope {
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
        }
    </style>
    <script>
        let self = this
        let addEvt = events.doc.add, delEvt = events.doc.remove
        let assigns = nlib.utils.assigns
        let clone = nlib.utils.clone, equals = nlib.utils.equals

        let partId = 'staff-entry'
        this.content = {
            entry: { 
                prefix: 'Prefix Name', 
                firstName: 'First Name', 
                lastName: 'Last Name', 
                userName: 'User Name', 
                passWord: 'Password',
                memberType: 'Member Type'
            }
        }
        this.isDefault = () => { return (opts.langid === '' || opts.langid === 'EN') }

        this.on('mount', () => {
            initCtrls()
            bindEvents()
        })
        this.on('unmount', () => {
            unbindEvents()
            freeCtrls()
        })
        let prefix, firstName, lastName, userName, passWord
        let memberTypes
        let initCtrls = () => {
            prefix = self.refs['prefix']
            firstName = self.refs['firstName']
            lastName = self.refs['lastName']
            userName = self.refs['userName']
            passWord = self.refs['passWord']
            memberTypes = self.refs['memberTypes']
        }
        let freeCtrls = () => {
            prefix = null
            firstName = null
            lastName = null
            userName = null
            passWord = null
            memberTypes = null
        }
        let clearInputs = () => {
            prefix.clear()
            firstName.clear()
            lastName.clear()
            userName.clear()
            passWord.clear()
            // required to check null in case some input(s) not used in
            // multilanguages tab
            if (memberTypes) memberTypes.clear()
        }
        let bindEvents = () => {
            addEvt(events.name.ContentChanged, onContentChanged)
        }
        let unbindEvents = () => {
            delEvt(events.name.ContentChanged, onContentChanged)
        }

        let onContentChanged = (e) => { updateContents(); }
        let updateContents = () => {
            // sync content by part id.
            let partContent = contents.getPart(partId)
            let propNames = [
                'entry.prefix',
                'entry.firstName',
                'entry.lastName',
                'entry.userName',
                'entry.passWord',
                'entry.memberType'
            ]
            assigns(self.content, partContent, ...propNames)
        }

        this.setup = (item) => {
            // set item (1 language)
        }
        this.refresh = () => { updateContents() }
    </script>
</staff-entry>