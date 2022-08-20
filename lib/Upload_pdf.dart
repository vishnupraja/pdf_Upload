
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';




class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _fileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _loadingPath = false;

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      print(_paths!.first.extension);
      _fileName =
      _paths != null ? _paths!.map((e) => e.name).toString() : '...';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Kindacode.com'),
        ),
        body:Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 13, right: 13),
                    child: InkWell(
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Image(
                                image: AssetImage('assets/UPload.png'),
                                height: 27,
                                width: 20,
                              ),
                            ),
                            Text(
                              'Upload Id proof ( Aadhar Card, Pan Card )',
                              style: TextStyle(
                                  fontSize: 10, color: Colors.black45),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          // color: Color(0xffF9D3B9),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.black38,
                          ),
                        ),
                        width: 310,
                        height: 70,
                      ),
                      onTap: () {
                        _openFileExplorer();
                      },
                    ),
                  )

                  // ElevatedButton(
                  //   onPressed: () => _selectFolder(),
                  //   child: const Text("Pick folder"),
                  // ),
                  // ElevatedButton(
                  //   onPressed: () => _clearCachedFiles(),
                  //   child: const Text("Clear temporary files"),
                  // ),
                ],
              ),
            ),
            Builder(
              builder: (BuildContext context) => _loadingPath
                  ? Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
              )
                  : _directoryPath != null
                  ? ListTile(
                title: const Text('Directory path'),
                subtitle: Text(_directoryPath!),
              )
                  : _paths != null
                  ? Container(
                padding:
                const EdgeInsets.only(bottom: 30.0),
                height:
                MediaQuery.of(context).size.height *
                    0.13,
                child: Scrollbar(
                    child: ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:
                      _paths != null && _paths!.isNotEmpty
                          ? _paths!.length
                          : 1,
                      itemBuilder:
                          (BuildContext context, int index) {
                        final bool isMultiPath =
                            _paths != null &&
                                _paths!.isNotEmpty;
                        final String name = 'File $index: ' +
                            (isMultiPath
                                ? _paths!
                                .map((e) => e.name)
                                .toList()[index]
                                : _fileName ?? '...');
                        final path = _paths!
                            .map((e) => e.path)
                            .toList()[index];

                        return ListTile(
                          title: Text(
                            name,
                          ),
                          subtitle: Text(path!),
                        );
                      },
                      separatorBuilder:
                          (BuildContext context, int index) =>
                      const Divider(),
                    )),
              )
                  : const SizedBox(
                height: 12,
              ),
            ),
          ],
        )
    );
  }
}