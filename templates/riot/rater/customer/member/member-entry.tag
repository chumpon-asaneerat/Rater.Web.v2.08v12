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
        let addEvt = events.doc.add, delEvt = events.doc.remove
        let assigns = nlib.utils.assigns
        let clone = nlib.utils.clone, equals = nlib.utils.equals

        let partId = 'member-entry'
        this.content = {
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
                employeeCode: 'Employee Code'
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
        //let tagId, idCard, employeeCode;
        let initCtrls = () => {
            prefix = self.refs['prefix']
            firstName = self.refs['firstName']
            lastName = self.refs['lastName']
            userName = self.refs['userName']
            passWord = self.refs['passWord']
            memberTypes = self.refs['memberTypes']
            /*
            tagId = self.refs['tagId']
            idCard = self.refs['idCard']
            employeeCode = self.refs['employeeCode']
            */
        }
        let freeCtrls = () => {
            prefix = null
            firstName = null
            lastName = null
            userName = null
            passWord = null
            memberTypes = null
            /*
            tagId = null
            idCard = null
            employeeCode = null
            */
        }
        let clearInputs = () => {
            prefix.clear()
            firstName.clear()
            lastName.clear()
            // required to check null in case some input(s) not used in
            // multilanguages tab
            if (userName) userName.clear()
            if (passWord) passWord.clear()
            if (memberTypes) memberTypes.clear()
            /*
            tagId.clear()
            idCard.clear()
            employeeCode.clear()
            */
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
                'entry.memberType',
                'entry.tagId',
                'entry.idCard',
                'entry.employeeCode'
            ]
            assigns(self.content, partContent, ...propNames)
        }

        let origObj
        let editObj
        let ctrlToObj = () => {
            if (editObj) {
                //console.log('ctrlToObj:', editObj)
                if (prefix) editObj.Prefix = prefix.value()
                if (firstName) editObj.FirstName = firstName.value()
                if (lastName) editObj.LastName = lastName.value()
                if (userName) editObj.UserName = userName.value()
                if (passWord) editObj.Password = passWord.value()
                if (memberTypes) editObj.MemberType = memberTypes.value()
                /*
                if (tagId) editObj.TagId = tagId.value()
                if (idCard) editObj.IDCard = idCard.value()
                if (employeeCode) editObj.EmployeeCode = employeeCode.value()
                */
            }
        }
        let objToCtrl = () => {
            if (editObj) {
                //console.log('objToCtrl:', editObj)
                if (prefix) prefix.value(editObj.Prefix)
                if (firstName) firstName.value(editObj.FirstName)
                if (lastName) lastName.value(editObj.LastName)
                if (userName) userName.value(editObj.UserName)
                if (passWord) passWord.value(editObj.Password)
                if (memberTypes && editObj.MemberType) {
                    memberTypes.value(editObj.MemberType.toString())
                }
                /*
                if (tagId) tagId.value(editObj.TagId)
                if (idCard) idCard.value(editObj.IDCard)
                if (employeeCode) employeeCode.value(editObj.EmployeeCode)
                */
            }
        }
        this.setup = (item, lookup) => {
            clearInputs()
            // set lookup.
            if (memberTypes) {
                memberTypes.setup(lookup.membertypes, { valueField:'memberTypeId', textField:'Description' });
            }

            origObj = clone(item)
            editObj = clone(item)
            //console.log('edit obj:', editObj)
            objToCtrl()
        }
        this.getItem = () => {
            ctrlToObj()
            //console.log('getItem:', editObj)
            let hasId = (editObj.memberId !== undefined && editObj.memberId != null)
            let isDirty = !hasId || !equals(origObj, editObj)
            //console.log(editObj)
            return (isDirty) ? editObj : null
        }
        this.refresh = () => { updateContents() }
    </script>
</member-entry>