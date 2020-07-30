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

