$(document).ready(function() {
    tinymce.init({
      selector: '.editor',
      height: 500,
      menubar: true,
      relative_urls: false,
      plugins: [
        'textcolor table advlist autolink lists link image charmap print preview anchor',
        'searchreplace visualblocks code fullscreen',
        'insertdatetime media table contextmenu paste code codesample imagetools wordcount'
      ],
      toolbar: 'undo redo | insert | styleselect | bold italic  | alignleft aligncenter alignright alignjustify | forecolor backcolor | bullist numlist outdent indent | codesample | removeformat',
      content_css: '/backend/tinymce/css/codepen.min.css, /backend/tinymce/css/custom_content.css' /*'//www.tinymce.com/css/codepen.min.css'*/
    });
});
$(document).ready(function() {
    tinymce.init({
      selector: '.editortiny',
      height: 100,
      menubar: false,
      relative_urls: false,
      plugins: [
        'advlist autolink lists link image charmap print preview anchor',
        'searchreplace visualblocks code fullscreen',
        'insertdatetime media table contextmenu paste code'
      ],
      toolbar: 'undo redo | insert | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | code',
      content_css: '/backend/tinymce/css/codepen.min.css, /backend/tinymce/css/custom_content.css', /*'//www.tinymce.com/css/codepen.min.css',*/
      statusbar: false,
    });

    $(document).ready(function() {
        $(document).on('click', '.editor-insert-image-button', function() {
            var button = $(this);
            var form = button.parents('form');
            var group = button.parents('.form-group');
            var file = group.find('input[name="editor_upload[image_url]"]');

            file.trigger('click');
        });
        $(document).on('change', 'input[name="editor_upload[image_url]"]', function() {
            var file = $(this);
            var form = file.parents('form');
            var formData = new FormData(form[0]);
            var url = file.attr('data-url');
            var editor_id = file.attr('editor-id');
            console.log(editor_id);
            $.ajax({
                url: url,
                type: 'POST',
                data: formData,
                async: false,
                success: function (imgsrc) {
                    tinymce.get(editor_id).execCommand(
                        'mceInsertContent',
                        false,
                        '<img src="'+imgsrc+'" />'
                    );
                },
                cache: false,
                contentType: false,
                processData: false
            });

            return false;
        });
    });
});
