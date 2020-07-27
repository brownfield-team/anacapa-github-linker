$(document).ready(function () {
    if ($(".courses-informed_consents-controller").length <= 0) {
        return;
    }
    console.log("ready fired in informed_consent.js")
    document.addEventListener("change", function (e) {
        informedConsentCSV(e)
    });
});
 

function informedConsentCSV(e) {
    console.log("informedConsentCSV");

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
            {value: 'student_id', name: 'Student ID'}, 
            {value: 'name', name: 'Name'},
            {value: 'student_consents', name: 'Student Consents'}, 
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
            console.log("cleanedCellValue="+cleanedCellValue);
            if (cleanedCellValue=="id") {
                dropdownIndex = cleanedDropdownValues.indexOf("studentid");
            }
            if (dropdownIndex > -1) {
                document.getElementById('dropdown-' + k).selectedIndex = dropdownIndex;
            }
        }
    };

    // process async above
    reader.readAsText(selectedFile);
    // console.log(CSVToArray(reader.readAsText(selectedFile)));

   
 }
 
 
 function uploadSubmitInformedConsents() {
 
    // validate

    // get array of selections
    var headings = $("#upload-modal select").map(function(){return $(this).val();}).get();
    console.log(headings);

    var missing_student_id = !headings.includes("student_id");
    var any_missing = headings.includes("invalid");

    if ( missing_student_id || any_missing) {
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