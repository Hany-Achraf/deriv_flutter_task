import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deriv_flutter_task/states/price/price_cubit.dart';
import 'package:deriv_flutter_task/data/streams/price_stream.dart';
import 'package:deriv_flutter_task/states/markets/markets_cubit.dart';
import 'package:deriv_flutter_task/data/repositories/markets_repository.dart';
import 'package:deriv_flutter_task/screens/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Price Tracker';
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.brown),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MarketsCubit(MarketsRepository()),
          ),
          BlocProvider(
            create: (context) => PriceCubit(PriceStream()),
          ),
        ],
        child: const HomeScreen(title: title),
      ),
    );
  }
}
