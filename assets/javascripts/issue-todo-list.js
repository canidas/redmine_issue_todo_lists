(function($) {
    "use strict";

    var fixWidth = function(e, ui) {
        ui.children().each(function() {
            $(this).width($(this).width());
        });

        return ui;
    };

    var calculateOddEvenStyle = function() {
        $('#issue-todo-list-table > tbody > tr').each(function(index, tr) {
            tr = $(tr);
            tr.removeClass('odd');
            tr.removeClass('even');

            if(index % 2 == 0) {
                tr.addClass('odd');
            } else {
                tr.addClass('even');
            }
        });
    };

    var updateOrder = function(e, ui) {
        var itemOrder = $('#issue-todo-list-table > tbody').sortable('serialize', {
            key: 'item[]'
        });

        $.ajax({
            type: 'POST',
            url: window.location.href + '/update_item_order',
            data: itemOrder,
            dataType: 'html',
            beforeSend: function(xhr) {
                xhr.setRequestHeader('Accept', 'text/javascript');
            },
            success: function(response) {
                eval(response);
            },
            error: function() {
                alert('Error while ordering. Please reload the page.');
            }}
        );

        calculateOddEvenStyle();
    };

    $(document).ready(function() {
        $('#issue-todo-list-table.sortable > tbody').sortable({
            cancel: 'a',
            //containment: 'parent',
            cursor: 'move',
            placeholder: 'issue-todo-list-drop',
            helper: fixWidth,
            update: updateOrder
        });
    });
})(jQuery);