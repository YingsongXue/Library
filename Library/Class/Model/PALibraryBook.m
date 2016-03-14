//
//  PALibraryBooks.m
//  Library
//
//  Created by 薛 迎松 on 10/16/15.
//  Copyright © 2015 薛 迎松. All rights reserved.
//

#import "PALibraryBook.h"

//http://api.douban.com/v2/book/isbn/9787115224637 //Douban page.
/*
 {
 "rating": {
 "max": 10,
 "numRaters": 62,
 "average": "8.2",
 "min": 0
 },
 "subtitle": "",
 "author": [
 "John M.Vlissides"
 ],
 "pubdate": "201005",
 "tags": [
 {
 "count": 87,
 "name": "设计模式",
 "title": "设计模式"
 },
 {
 "count": 18,
 "name": "软件工程",
 "title": "软件工程"
 },
 {
 "count": 11,
 "name": "程序设计",
 "title": "程序设计"
 },
 {
 "count": 10,
 "name": "设计",
 "title": "设计"
 },
 {
 "count": 10,
 "name": "Design",
 "title": "Design"
 },
 {
 "count": 9,
 "name": "计算机",
 "title": "计算机"
 },
 {
 "count": 9,
 "name": "Pattern",
 "title": "Pattern"
 },
 {
 "count": 6,
 "name": "计算机科学",
 "title": "计算机科学"
 }
 ],
 "origin_title": "Pattern Hatching: Design Patterns Applied",
 "image": "http://img3.douban.com/mpic/s4342234.jpg",
 "binding": "平装",
 "translator": [
 "葛子昂"
 ],
 "catalog": "第1章　介绍　　1.1　对模式的十大误解　　1.2　观察　第2章　运用模式进行设计　　2.1　基础　　2.2　孤儿、孤儿的收养以及代用品　　2.3　“但是应该如何引入代用品呢？”　　2.4　访问权限　　2.5　关于 VISITOR的一些警告　　2.6　单用户文件系统的保护　　2.7　多用户文件系统的保护　　2.8　小结　第3章　主体和变体　　3.1　终止SINGLETON　　3.2　OBSERVER的烦恼　　3.3　重温VISITOR　　3.4　GENERATION GAP　　3.5　Type Laundering　　3.6　感谢内存泄漏　　3.7　推拉模型　第4章　爱的奉献　第5章　高效模式编写者的7个习惯　　5.1　习惯1：经常反思　　5.2　习惯2：坚持使用同一套结构　　5.3　习惯3：尽早且频繁地涉及具体问题　　5.4　习惯4：保持模式间的区别和互补性　　5.5　习惯5：有效地呈现　　5.6　习惯6：不懈地重复　　5.7　习惯7：收集并吸取反馈　　5.8　没有银弹　参考文献　索引",
 "pages": "152",
 "images": {
 "small": "http://img3.douban.com/spic/s4342234.jpg",
 "large": "http://img3.douban.com/lpic/s4342234.jpg",
 "medium": "http://img3.douban.com/mpic/s4342234.jpg"
 },
 "alt": "http://book.douban.com/subject/4816447/",
 "id": "4816447",
 "publisher": "人民邮电出版社",
 "isbn10": "7115224633",
 "isbn13": "9787115224637",
 "title": "设计模式沉思录",
 "url": "http://api.douban.com/v2/book/4816447",
 "alt_title": "Pattern Hatching: Design Patterns Applied",
 "author_intro": "John Vlissides（1961—2005） 设计模式四人帮之一，《设计模式》一书的作者。曾在斯坦福大学工作，自1991年起任IBM T. J. Watson研究中心的研究员。他还曾是《程序设计的模式语言》的编辑，Addison-Wesley“软件模式”丛书的顾问。因患脑瘤于2005年感恩节（11月24日）病故。为纪念他的贡献，ACM SIGPLAN特设立了John Vlissides奖。\n葛子昂 现任微软中国研发集团服务器及开发工具事业部的软件开发主管，目前从事WF的相关开发，致力于为WF开发人员提供方便高效的开发工具。之前曾长期从事WCF产品的相关研发，具有丰富的开发经验。出版译作有《.NET设计规范（第2版）》、《Windows核心编程（第5版）》。",
 "summary": "本书作者是设计模式的开山鼻祖之一。在本书中，他不仅通过一些通俗易懂的实例对如何运用设计模式进行了深入的讲解，而且还介绍了一些新的设计模式。同时还讲述了模式背后鲜为人知的一些故事，让读者领略其中的苦与乐。\n本书帮助读者在面向对象设计的基本原则下，将设计模式运用到合适的地方。它道出了虽然不正式、但却严格的标准，展现了紧张的迭代过程，《设计模式》中的23个模式正是基于这样的标准，经历了这样的迭代过程产生的。读者理解了这一点，将有助于把模式应用到讲究实用的日常工作中，认识到必须根据手头的问题来对模式进行调整，并加入自己的思考而不仅仅是盲目地遵循书本教条。通过反复品味，读者有朝一日终能编写出自己的模式！",
 "price": "35.00元"
 }
 */

@implementation PALibraryBook

+ (PABookKeyType)typeOf:(NSString *)str
{
    if (str && [str isKindOfClass:[NSString class]]) {
        if (str.length == 10) {
            return PABookKeyTypeISBN10;
        }
        else if(str.length == 13)
        {
            return PABookKeyTypeISBN13;
        }
    }
    return PABookKeyTypeUnknown;
}

+ (NSArray *)book
{
    return @[@"id", @"isbn10", @"isbn13", @"title", @"origin_title", @"subtitle", @"url",  @"alt", @"alt_title", @"summary", @"author_intro", @"price", @"pages", @"pubdate", @"catalog", @"binding", @"publisher",
             @"image", @"images", @"translator", @"rating", @"tags"];
    //images is a array
    //translator is a array
    //rating is a dictionary
    //tags is a array<dictionary>
}

+ (NSArray *)bookInfoOf:(NSString *)more
{
    return @{@"images":@[@"small", @"medium", @"large"], @"tags":@[@"count", @"name", @"title"]}[more];
}
@end
