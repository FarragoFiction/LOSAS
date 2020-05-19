import 'DataStringHelper.dart';

abstract class DataObject {
    String name;
    Map<String, dynamic> getSerialization() {

    }
    String toString() => name;

    String toDataString() {
        return DataStringHelper.serializationToDataString(name,getSerialization());
    }

    void loadFromSerialization(Map<String, dynamic> serialization);

    void loadFromDataString(String dataString);

}