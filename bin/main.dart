import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:televerse/televerse.dart';
import 'package:webdriver/sync_io.dart';

import 'domain/document_dart.dart';
import 'domain/tiсket.dart';

final DotEnv env = DotEnv(includePlatformEnvironment: true)..load();
final Televerse bot = Bot(env["BOT_TG_TOKEN"]!);
final Conversation conversation = Conversation(bot);

void main(List<String> args) async {
  try {
    var documentDart = DocumentDart();
    await documentDart.instanceStatus;

    bot.command('list', (ctx) async {
      var usersIncomingMessage;
      do {
        Ticket? ticket = DocumentDart.getQuestionCollection('list');
        print(ticket);
        await ctx.reply(ticket.toString());
        usersIncomingMessage =
            await conversation.waitForTextMessage(chatId: ctx.id);
        if (ticket!.isCheck(int.parse(usersIncomingMessage.message.text))) {
          await ctx.reply('Good');
        } else {
          await ctx.reply('Bad');
        }
      } while (usersIncomingMessage.message.text.toString() != 'exit');
    });
    // bot.command('set', (ctx) async {});
    // bot.command('map', (ctx) async {});
    // bot.command('list', (ctx) async {});

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
