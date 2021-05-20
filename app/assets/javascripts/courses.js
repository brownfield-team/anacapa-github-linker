$(document).ready(function () {
    if ($(".courses-controller").length <= 0) {
        return;
    }
    document.addEventListener("change", function (e) {
      courseRosterCSV(e) 
     });
 });
 
 function courseRosterCSV(e) {

    // when file is uploaded, grab it
    var selectedFile = e.target.files[0];

    var reader = new FileReader();

    reader.onload = function (e) {
        // process result of the read
        var text = reader.result;
        var parsedFile = CSVToArray(text);

        // now generate table
        $("#upload-modal").modal();

        var dropdownHtml =
            "<td>" +
            "<select id='dropdown-%i%' index='%i%' class='form-control input-sm' style='width: auto;" +
            " font-weight:" +
            " bold;'>";

        var fields = [
            {value: 'select', name: '-- select --'}, 
            {value: 'full_name', name: 'Full Name'},
            {value: 'first_name', name: 'First Name'}, 
            {value: 'last_name', name: 'Last Name'},
            {value: 'student_id', name: 'Student ID'}, 
            {value: 'email', name: 'Email'}, 
            {value: 'section', name: 'Section'},
            {value: 'github_username', name: 'Github Username'},
        ];

        for (var i = 0; i < fields.length; i++) {
            dropdownHtml += "<option value='" + fields[i].value + "' >" + fields[i].name + "</option>";
        }
        dropdownHtml += "</select>" +
            "</td>";

        var dropdownRow = "<tr>";
        for (var i = 0; i < parsedFile[0].length; i++) {
            dropdownRow += dropdownHtml.replace('%i%', i);
        }
        dropdownRow += "</tr>";
        $("#upload-modal .table").append(dropdownRow);

        var rowsToShow = 6;
        //Assumes every row has the same length
        for (var i = 0; i < parsedFile.length && i < rowsToShow; i++) {
            var newRow = "<tr>";
            var rowSize = 0;
            for (var j = 0; j < parsedFile[0].length; j++) {

                rowSize += parsedFile[i].length;
                newRow += ("<td>" + parsedFile[i][j] + "</td>");
        }
        newRow += "</tr>";

            if (rowSize > 0) { // skip empty rows
            $("#upload-modal .table").append(newRow);
            }
        }
        var rowsNotShownStr = (parsedFile.length - rowsToShow) + " rows not shown.";
        document.getElementById('rows-not-shown').textContent = rowsNotShownStr;

        // Basic auto matching of fields to dropdown

        var cleanedDropdownValues = fields.map(function(f) { return f.value.replace(/[^0-9a-z]/gi, '').toLowerCase(); });
        for (var k = 0; k < parsedFile[0].length; k++) {
            var cleanedCellValue = parsedFile[0][k].replace(/[^0-9a-z]/gi, '').toLowerCase();
            var dropdownIndex = cleanedDropdownValues.indexOf(cleanedCellValue);
            if (dropdownIndex > -1) {
                document.getElementById('dropdown-' + k).selectedIndex = dropdownIndex;
            }
        }
    };

    // process async above
    reader.readAsText(selectedFile);
    // console.log(CSVToArray(reader.readAsText(selectedFile)));

 }

 
 
 
 function uploadSubmitRosterStudents() {
 
     // validate
 
     // get array of selections
     var headings = $("#upload-modal select").map(function(){return $(this).val();}).get();
 
     var full_split_name_error = headings.includes("full_name") && (headings.includes("first_name") || headings.includes("first_name"));
     var missing_student_id = !headings.includes("student_id");
     var missing_email = !headings.includes("email");
     var any_missing = headings.includes("invalid");
     var first_name_wo_last_name = headings.includes("first_name") && !headings.includes("last_name");
     var last_name_wo_first_name = headings.includes("last_name") && !headings.includes("first_name");
 
     if (full_split_name_error || missing_student_id || missing_email || first_name_wo_last_name || last_name_wo_first_name || any_missing) {
         if ($("#csv-upload-error").hasClass('hidden')) {
             $("#csv-upload-error").removeClass( "hidden" );
         } else {
             $("#csv-upload-error").effect( "shake" );
         }
     } else {
         $("#csv-upload-error").addClass( "hidden" );
         // valid - g2g
 
         // pull data from our psuedo-form into the hidden elements before posting
         // might be better to put this in a little json hash instead
         $("#csv-header-map-hidden-field").val(headings.join(','));
         if($("#first-row-is-header").is(':checked')){
            $("#csv-header-toggle-hidden-field").val("true");
         }
         else{
            $("#csv-header-toggle-hidden-field").val("false");
         }
 
 
         $("#roster-upload-form").submit();
     }
 }
 
 function headerToggle(caller) {
     var checked = $(caller).is(':checked');
     if (checked) {
         $("#upload-modal table").addClass("first-row-disabled");
     } else {
         $("#upload-modal table").removeClass("first-row-disabled");
     }
 }