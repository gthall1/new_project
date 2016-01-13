var tabs = {
    conf: {
        tab: '.tab-section'
    },

    switch: function($tab) {
        var tabCategory = $tab.data('tab-cat');

        $('.tab-toggle').removeClass('active');
        $tab.addClass('active');
        $(tabs.conf.tab).addClass('hidden');

        $(tabCategory).removeClass('hidden');
    },

    bind: function() {
        $('.tab-toggle').click(function(e){
            tabs.switch($(this));
        });
    },

    init: function() {
        tabs.bind();
    }
};
