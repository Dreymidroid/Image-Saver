import 'package:flutter/material.dart';
import 'dart:math' as math show Random;
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        home: BlocProvider(
          create: (_) => ABloc(),
          child: const HomePage(),
        ),
      ),
    );

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class ABloc extends Bloc<BlocTestEvent, BlocTestState?> {
  ABloc() : super(null) {
    on<Event1>(
      (event, emit) => emit(BlocTestState()),
    );
    on<Event2>(
      (event, emit) => emit(BlocTestState()),
    );
  }
}

class BlocTestEvent {}

class Event1 extends BlocTestEvent {}

class Event2 extends BlocTestEvent {
}

class BlocTestState {}

const names = ["Foo", "Bar", "Baz"];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);

  void pickRandomName() => emit(
        names.getRandomElement(),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NamesCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = NamesCubit();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctxt) {

    return Scaffold(
        appBar: AppBar(),
        body: StreamBuilder<String?>(
          stream: cubit.stream,
          builder: (ctxt, snapshot) {
            final button = TextButton(
              onPressed: () => cubit.pickRandomName(),
              child: const Text("Click"),
            );

            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return button;
              case ConnectionState.waiting:
                return button;
              case ConnectionState.active:
                return Column(
                  children: [
                    BlocBuilder<ABloc, BlocTestState?>(
                        builder: (context, state) {
                      return Text(
                        snapshot.data ?? state.toString(),
                      );
                    }),
                    button,
                  ],
                );
              case ConnectionState.done:
                return const SizedBox();
            }
          },
        ));
  }
}
