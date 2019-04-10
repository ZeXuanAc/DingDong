import 'dart:convert';

void main() {
    JsonCodec codec = new JsonCodec();
    try{
        var decoded = json.decode("[{id:1, text:'fdsf', completed: false},{id:2, text:'qwer', completed: true}]");
        print("Decoded 1: $decoded");
    } catch(e) {
        print("Error: $e");
    }

    try{
        var decoded = json.decode("""[{"id":1, "text":"fdsf", "completed": false},{"id":2, "text":"qwer", "completed": true}]""");
        print("Decoded 2: $decoded");
    } catch(e) {
        print("Error: $e");
    }
}