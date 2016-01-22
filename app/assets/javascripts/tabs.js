var tabs = {
    selections: {
        tabContainer: '.js-tab-section',
        tabControl:   '.js-tab-toggle'
    },

    toggle: function($tab) {
        // Weekly or All-Time
        var tabCategory = $tab.data('tab-cat');

        $(tabs.selections.tabControl).removeClass('active');
        $tab.addClass('active');
        $(tabs.selections.tabContainer).addClass('hidden');

        $(tabCategory).removeClass('hidden');
    },

    bind: function() {
        $(tabs.selections.tabControl).click(function(e){
            var $this = $(this);

            tabs.toggle($this);
        });
    },

    init: function() {
        tabs.bind();
    }
};
