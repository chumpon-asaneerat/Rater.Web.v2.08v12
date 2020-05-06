let getValue = (obj, property) => {
    let props = property.split('.')
    let prop
    let ref = obj
    while (props.length > 0 && ref) {
        prop = props.shift()
        ref = (ref[prop]) ? ref[prop] : null
    }
    return ref;
}

let setValue = (obj, property, value) => {
    let props = property.split('.')
    let prop
    let ref = obj
    let iCnt = 0
    let iMax = props.length
    while (props.length > 0 && ref) {
        prop = props.shift()        
        iCnt++
        if (iCnt < iMax) {
            ref = (ref[prop]) ? ref[prop] : null
        }
        else {
            ref[prop] = value
        }
    }
}

let screen = {
    labels: {
        header: 'header',
        footer: 'footer',
        inputs: {
            hint: 'hint'
        }
    }
}

console.log(screen)
setValue(screen, 'labels.footer', 'new footer')
console.log(getValue(screen, 'labels.footer'))
console.log(screen)
