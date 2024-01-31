import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:televerse/televerse.dart';
import 'package:webdriver/sync_io.dart';

import 'domain/document_dart.dart';
import 'domain/tiсket.dart';

final DotEnv env = DotEnv(includePlatformEnvironment: true)..load();
final Televerse bot = Bot(env["BOT_TG_TOKEN"]!);
final Conversation conversation = Conversation(bot);
final keyboardMenu = KeyboardMenu(name: "my-menu")
    .text("1", (ctx) async {})
    .text("2", (ctx) async {})
    .row()
    .text("3", (ctx) async {})
    .text("4", (ctx) async {})
// .requestLocation("Send Me Location", locationCallback)
    .oneTime()
    .resized();
// Add more buttons as needed

// Settings callback
Future<void> settingsCallback(Context ctx) async {
  // Reply settings
  await ctx.reply(
    "Here are the bot settings",
  );
}

// Handle the incoming location message
Future<void> locationCallback(Context ctx) async {
  // Reply with the location data
  await ctx.reply(
    "You are at ${ctx.message?.location?.latitude}, ${ctx.message?.location?.longitude}",
  );
}

void main(List<String> args) async {
  bot.attachMenu(keyboardMenu);
  try {
    var documentDart = DocumentDart();
    await documentDart.instanceStatus;

    bot.command('list', (ctx) async {
      runSurveu(ctx, 'list');
    });
    bot.command('set', (ctx) async {
      runSurveu(ctx, 'set');
    });
    bot.command('map', (ctx) async {
      runSurveu(ctx, 'map');
    });
    bot.command('iterable', (ctx) async {
      runSurveu(ctx, 'iterable');
    });

    bot.start((ctx) async {
      ctx.react("🎉", isBig: true);
    });

    print('the program is running');
  } catch (e) {
    print(e);
  } finally {
    // driver.quit();
  }
}

runSurveu(ctx, String Subject) async {
  var usersIncomingMessage;
  do {
    Ticket? ticket = DocumentDart.getQuestionCollection(Subject);
    print(ticket);
    await ctx.reply(
      ticket.toString(),
      replyMarkup: keyboardMenu,
    );
    usersIncomingMessage =
        await conversation.waitForTextMessage(chatId: ctx.id);
    try {
      if (ticket!.isCheck(int.parse(usersIncomingMessage.message.text))) {
        await ctx.reply('Good');
      } else {
        await ctx.reply('Bad');
      }
    } catch (e) {
      print(e);
    }
  } while (usersIncomingMessage.message.text.toString() != 'exit');
}
