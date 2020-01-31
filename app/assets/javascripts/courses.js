$(document).ready(function () {

    document.addEventListener("change", function (e) {

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

            let fields = [{value: 'select', 'name': '-- select --'}, {value: 'full_name', name: 'Full Name'},
                {value: 'first_name', name: 'First Name'}, {value: 'last_name', name: 'Last Name'},
                {value: 'perm', name: 'Perm'}, {value: 'email', name: 'Email'}];

            for (const field of fields) {
                dropdownHtml += "<option value='" + field.value + "' >" + field.name + "</option>";
            }
            dropdownHtml += "</select>" +
                "</td>";

            var dropdownRow = "<tr>";
            for (var i = 0; i < parsedFile[0].length; i++) {
                dropdownRow += dropdownHtml.replace('%i%', i);
            }
            dropdownRow += "</tr>";
            $("#upload-modal .table").append(dropdownRow);

            const rowsToShow = 6;
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
            let rowsNotShownStr = (parsedFile.length - rowsToShow) + " rows not shown.";
            document.getElementById('rows-not-shown').textContent = rowsNotShownStr;

            // Basic auto matching of fields to dropdown
             let cleanedDropdownValues = fields.map(f => f.value.replace(/[^0-9a-z]/gi, '').toLowerCase());
             for (var k = 0; k < parsedFile[0].length; k++) {
                 let cleanedCellValue = parsedFile[0][k].replace(/[^0-9a-z]/gi, '').toLowerCase();
                 let dropdownIndex = cleanedDropdownValues.indexOf(cleanedCellValue);
                if (dropdownIndex > -1) {
                    document.getElementById('dropdown-' + k).selectedIndex = dropdownIndex;
                }
             }
         };
 
         // process async above
         reader.readAsText(selectedFile);
         // console.log(CSVToArray(reader.readAsText(selectedFile)));
 
     });
 
 });
 
 // http://stackoverflow.com/questions/1293147/javascript-code-to-parse-csv-data
 // yay cargo cult programming
 function CSVToArray( strData, strDelimiter ){
     // Check to see if the delimiter is defined. If not,
     // then default to comma.
     strDelimiter = (strDelimiter || ",");
 
     // Create a regular expression to parse the CSV values.
     var objPattern = new RegExp(
         (
             // Delimiters.
             "(\\" + strDelimiter + "|\\r?\\n|\\r|^)" +
 
             // Quoted fields.
             "(?:\"([^\"]*(?:\"\"[^\"]*)*)\"|" +
 
             // Standard fields.
             "([^\"\\" + strDelimiter + "\\r\\n]*))"
         ),
         "gi"
         );
 
 
     // Create an array to hold our data. Give the array
     // a default empty first row.
     var arrData = [[]];
 
     // Create an array to hold our individual pattern
     // matching groups.
     var arrMatches = null;
 
 
     // Keep looping over the regular expression matches
     // until we can no longer find a match.
     while (arrMatches = objPattern.exec( strData )){
 
         // Get the delimiter that was found.
         var strMatchedDelimiter = arrMatches[ 1 ];
 
         // Check to see if the given delimiter has a length
         // (is not the start of string) and if it matches
         // field delimiter. If id does not, then we know
         // that this delimiter is a row delimiter.
         if (
             strMatchedDelimiter.length &&
             strMatchedDelimiter !== strDelimiter
             ){
 
             // Since we have reached a new row of data,
             // add an empty row to our data array.
             arrData.push( [] );
 
         }
 
         var strMatchedValue;
 
         // Now that we have our delimiter out of the way,
         // let's check to see which kind of value we
         // captured (quoted or unquoted).
         if (arrMatches[ 2 ]){
 
             // We found a quoted value. When we capture
             // this value, unescape any double quotes.
             strMatchedValue = arrMatches[ 2 ].replace(
                 new RegExp( "\"\"", "g" ),
                 "\""
                 );
 
         } else {
 
             // We found a non-quoted value.
             strMatchedValue = arrMatches[ 3 ];
         }
 
         // Now that we have our value string, let's add
         // it to the data array.
         arrData[ arrData.length - 1 ].push( strMatchedValue );
     }
 
     // Return the parsed data.
     return( arrData );
 }
 
 function uploadSubmit() {
 
     // validate
 
     // get array of selections
     var headings = $("#upload-modal select").map(function(){return $(this).val();}).get();
     console.log(headings);
 
     var full_split_name_error = headings.includes("full_name") && (headings.includes("first_name") || headings.includes("first_name"));
     var missing_perm = !headings.includes("perm");
     var missing_email = !headings.includes("email");
     var any_missing = headings.includes("invalid");
     var first_name_wo_last_name = headings.includes("first_name") && !headings.includes("last_name");
     var last_name_wo_first_name = headings.includes("last_name") && !headings.includes("first_name");
 
     if (full_split_name_error || missing_perm || missing_email || first_name_wo_last_name || last_name_wo_first_name || any_missing) {
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