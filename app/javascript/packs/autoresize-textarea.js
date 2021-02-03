function addAutoResize() {
    document.querySelectorAll('.autoresize').forEach(function (element) {
        element.style.boxSizing = 'border-box';
        element.style.height = element.scrollHeight + offset + 'px';
        var offset = element.offsetHeight - element.clientHeight;
        element.addEventListener('input', function (event) {
            event.target.style.height = 'auto';
            event.target.style.height = event.target.scrollHeight + offset + 'px';
        });
        element.removeAttribute('autoresize');
        var event = new Event('input')
        element.dispatchEvent(event);
    });
}

addAutoResize();