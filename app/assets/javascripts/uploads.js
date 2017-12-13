$(document).on("turbolinks:load", function() {
  $("input[type=file]").fileupload({
    add: function(e, data) {
      console.log("add", data);
      data.progressBar = $('<progress class="progress is-success" max="100"></progress>').insertAfter("body");
      var options = {
        extension: data.files[0].name.match(/(\.\w+)?$/)[0], // set the file extension
        _: Date.now() // prevent caching
      };

      $.getJSON("/presign", options, function(result) {
        console.log("presign", result);
        data.formData = result.fields;
        data.url = result.url;
        data.paramName = 'file';
        data.submit();
      })
    },

    progress: function(e, data) {
      console.log("progress", data);
      var progress = parseInt(data.loaded / data.total * 100, 10);
      var percentage = progress.toString() + '%';
      data.progressBar.attr("value", progress);
    },

    done: function(e, data) {
      console.log("done", data);
      data.progressBar.remove();

      var document = {
        id:       data.formData.key.match(/cache\/(.+)/)[1], // we have to remove the prefix part
        storage:  'cache',
        metadata: {
          size:      data.files[0].size,
          filename:  data.files[0].name.match(/[^\/\\]+$/)[0], // IE return full path
          mime_type: data.files[0].type
        }
      };

      var form = $(this).closest("form");
      var formData = new FormData(form[0]);

      formData.append($(this).attr("name"), JSON.stringify(document));

      $.ajax(form.attr("action"), {
        contentType: false,
        processData: false,
        data: formData,
        method: form.attr("method"),
        dataType: "script"
      }).done(function(data) {
        console.log("done from Rails", data);
      });
    }
  });
});
