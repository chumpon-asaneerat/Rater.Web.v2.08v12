<member-entry>
    <div class="padtop"></div>
    <div class="padtop"></div>
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
        <!--
        <ninput ref="tagId" title="{ content.label.member.entry.tagId }" type="text" name="tagId"></ninput>
        <ninput ref="idCard" title="{ content.label.member.entry.idCard }" type="text" name="idCard"></ninput>
        <ninput ref="employeeCode" title="{ content.label.member.entry.employeeCode }" type="text" name="employeeCode"></ninput>
        -->
    </virtual>
    <style>
        :scope {
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
        }
        :scope .padtop {
            display: block;
            margin: 0 auto;
            width: 100%;
            min-height: 10px;
        }
    </style>
    <script>
        let self = this
        let screenId = 'member-entry'
        this.isDefault = () => { return (opts.langid === '' || opts.langid === 'EN') }

        let defaultContent = {
            title: 'Member Edit',
            entry: { 
                prefix: 'Prefix Name', 
                firstName: 'First Name', 
                lastName: 'Last Name', 
                userName: 'User Name', 
                passWord: 'Password',
                memberType: 'Member Type',
                tagId: 'Tag ID',
                idCard: 'ID Card',
                employeeCode: 'Employee Code',
            }
        }
        this.content = defaultContent;

        let addEvt = events.doc.add, delEvt = events.doc.remove
        this.on('mount', () => {
            initCtrls()
            bindEvents()
        })
        this.on('unmount', () => {
            unbindEvents()
            freeCtrls()
        })
        let prefix, firstName, lastName, userName, passWord;
        //let memberType;
        let memberTypes;
        //let tagId, idCard, employeeCode;
        let initCtrls = () => {
            prefix = self.refs['prefix'];
            firstName = self.refs['firstName'];
            lastName = self.refs['lastName'];
            userName = self.refs['userName'];
            passWord = self.refs['passWord'];
            memberTypes = self.refs['memberTypes'];
            /*
            tagId = self.refs['tagId'];
            idCard = self.refs['idCard'];
            employeeCode = self.refs['employeeCode'];
            */
        }
        let freeCtrls = () => {
            prefix = null;
            firstName = null;
            lastName = null;
            userName = null;
            passWord = null;
            memberTypes = null;
            /*
            tagId = null;
            idCard = null;
            employeeCode = null;
            */
        }
        let clearInputs = () => {
            prefix.clear()
            firstName.clear()
            lastName.clear()
            userName.clear()
            passWord.clear()
            // required to check null in case some input(s) not used in
            // multilanguages tab
            if (memberTypes) memberTypes.clear();
            /*
            tagId.clear()
            idCard.clear()
            employeeCode.clear()
            */
        }
        let bindEvents = () => {
            addEvt(events.name.LanguageChanged, onLanguageChanged)
            addEvt(events.name.ContentChanged, onContentChanged)
            addEvt(events.name.ScreenChanged, onScreenChanged)
            //addEvt(events.name.MemberTypeListChanged, onMemberTypeListChanged)
        }
        let unbindEvents = () => {
            //delEvt(events.name.MemberTypeListChanged, onMemberTypeListChanged)
            delEvt(events.name.ScreenChanged, onScreenChanged)
            delEvt(events.name.ContentChanged, onContentChanged)
            delEvt(events.name.LanguageChanged, onLanguageChanged)
        }

        let onContentChanged = (e) => { updatecontent(); }
        let onLanguageChanged = (e) => { updatecontent(); }
        let onScreenChanged = (e) => { updatecontent(); }
        let updatecontent = () => {
            if (screens.is(screenId)) {
                let scrContent = contents.getScreenContent()
                self.content = scrContent ? scrContent : defaultContent;
                self.update();
            }
        }
    </script>
</member-entry>