export default function vectorToCounts(vector) {
    let counts = {}
    vector.forEach(
        (item) => {
            if (item in counts)
                counts[item] ++
            else
                counts[item] = 1
        }
    )
    return counts;
}

export function combineCounts (counts1,counts2) {
    let result = {}
    Object.keys(counts1).forEach(
        (key) => {
            result[key] = counts1[key]
        }
    );
    Object.keys(counts2).forEach(
        (key) => {
            if (key in result) {
                result[key] += counts2[key]
            } else {
                result[key] = counts2[key]
            }
        }
    )
    return result;
}

export function vectorToObject (vector, func) {
    let result = {}
        vector.forEach(
            (value)=>{
                result[value] = func(value);
            }
        )
    return result
}

    // See: https://www.w3schools.com/jsref/jsref_obj_error.asp
    // Purpose: Turn the object that is the result of a catch 
    //  into a plain old object that can be serialized to JSON with
    //  information about the error.
    //
    //  Usage: 
    //  try {
    //      // some code
    //  } catch (e) {
    //     let error = errorToObject(e);
    //     console.log(`Error: ${JSON.stringify(error,null,2)}`)
    //  }
export function errorToObject(error) {
    let result = {}
    result.name = error.name;
    result.message = error.message;
    try { result.fileName = error.fileName } catch (_x) {}
    try { result.lineNumber = error.lineNumber } catch (_x) {}
    try { result.columnNumber = error.columnNumber } catch (_x) {}
    try { result.stack = error.stack } catch (_x) {}
    try { result.description = error.description } catch (_x) {}
    try { result.number = error.number } catch (_x) {}
    return result
}