let app

;(() => {
    let tags = riot.mount('rater-web-app')
    let tree = tags[0].tags['napp'].tags['screen'].tags['ntree']
    console.log(tree)
    /*
    let items = [
        { id: 'A001', name: 'Computer' },
        { id: 'A002', name: 'Notebook' },
        { id: 'A003', name: 'Smartphone' },
        { id: 'A004', name: 'Printer' },
        { id: 'A005', name: 'Router' }
    ]
    let fldmap = { valueField:'id', textField:'name' }
    let changeCallback = () => {
        console.log('selection changed: ', select.value())
        console.log('selected item: ', select.selectedItem())
    }
    tree.setup(items, fldmap, changeCallback)
    */
})()
