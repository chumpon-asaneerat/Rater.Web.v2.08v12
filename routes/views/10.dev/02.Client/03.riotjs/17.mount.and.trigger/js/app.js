let app

const eventbus = function() {
    console.log('init event bus.')
    riot.observable(this)
}

riot.hook = (tag) => {
    tag.on('before-mount', () => { 
        //console.log(tag.__.tagName, ' before-mount.')
        //riot.eventbus.trigger('update-tag-count')
        riot.tagCount++
    })
    tag.on('mount', () => {
        //console.log(tag.__.tagName, ' mounted. group: ', tag.opts.group)
        //riot.eventbus.trigger('update-tag-mount')
        riot.tagCount--
        if (riot.tagCount <= 0) {
            riot.eventbus.trigger('all-tags-mounted')
        }
        })
    tag.on('unmount', () => {
        console.log(tag.__.tagName, ' unmount')
    })
}

riot.tagCount = 0
riot.eventbus = new eventbus()
riot.eventbus.on('all-tags-mounted', () => {
    console.log('all tags mounted')
})
/*
riot.eventbus.on('update-tag-count', () => {
    riot.tagCount++
})
riot.eventbus.on('update-tag-mount', () => {
    riot.tagCount--
    if (riot.tagCount <= 0) {
        riot.eventbus.trigger('all-tags-mounted')
    }
})
*/

;(() => {
    app = riot.mount('rater-web-app')
})()
