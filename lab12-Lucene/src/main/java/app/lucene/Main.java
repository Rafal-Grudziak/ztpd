package app.lucene;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.en.EnglishAnalyzer;
import org.apache.lucene.analysis.pl.PolishAnalyzer;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.*;
import org.apache.lucene.index.*;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.search.*;
import org.apache.lucene.store.ByteBuffersDirectory;
import org.apache.lucene.store.Directory;

public class Main {
    
    private static Document buildDoc(String title, String isbn) {
        Document doc = new Document();
        doc.add(new TextField("title", title, Field.Store.YES));
        doc.add(new StringField("isbn", isbn, Field.Store.YES));
        return doc;
    }

    private static void runQuery(String label, String queryStr, Analyzer analyzer,
                                 IndexSearcher searcher) throws Exception {

        Query q = new QueryParser("title", analyzer).parse(queryStr);
        TopDocs results = searcher.search(q, 10);

        System.out.println("\n" + label + " - " + results.scoreDocs.length + " matching");

        for (ScoreDoc sd : results.scoreDocs) {
            Document d = searcher.storedFields().document(sd.doc);
            System.out.println("  " + d.get("title"));
        }
    }


    public static void main(String[] args) throws Exception {
        
        Analyzer analyzer = new StandardAnalyzer();
        Directory directory = new ByteBuffersDirectory();
        IndexWriterConfig config = new IndexWriterConfig(analyzer);
        IndexWriter w = new IndexWriter(directory, config);

        w.addDocument(buildDoc("Lucene in Action", "9781473671911"));
        w.addDocument(buildDoc("Lucene for Dummies", "9780735219090"));
        w.addDocument(buildDoc("Managing Gigabytes", "9781982131739"));
        w.addDocument(buildDoc("The Art of Computer Science", "9781250301695"));
        w.addDocument(buildDoc("Dummy and yummy title", "9780525656161"));

        w.close();

        String queryStr = "*:*";
        Query q = new QueryParser("title", analyzer).parse(queryStr);

        int maxHits = 10;
        IndexReader reader = DirectoryReader.open(directory);
        IndexSearcher searcher = new IndexSearcher(reader);
        TopDocs docs = searcher.search(q, maxHits);
        ScoreDoc[] hits = docs.scoreDocs;

        System.out.println("Found " + hits.length + " matching docs.");

        StoredFields storedFields = searcher.storedFields();
        for(int i=0; i<hits.length; ++i) {
            int docId = hits[i].doc;
            Document d = storedFields.document(docId);
            System.out.println((i + 1) + ". " + d.get("isbn")
                    + "\t" + d.get("title"));
        }

        // 7a
        Query qDummy = new QueryParser("title", analyzer).parse("dummy");
        TopDocs dummyResults = searcher.search(qDummy, 10);
        System.out.println("\n7a " + dummyResults.scoreDocs.length + " matching");

        for (ScoreDoc sd : dummyResults.scoreDocs) {
            Document d = searcher.storedFields().document(sd.doc);
            System.out.println("  " + d.get("title"));
        }

        // 7b
        Query qAndStd = new QueryParser("title", analyzer).parse("and");
        TopDocs andStdResults = searcher.search(qAndStd, 10);
        System.out.println("\n7b " + andStdResults.scoreDocs.length + " matching");

        for (ScoreDoc sd : andStdResults.scoreDocs) {
            Document d = searcher.storedFields().document(sd.doc);
            System.out.println("  " + d.get("title"));
        }


        // 9a
        Query qDummyEn = new QueryParser("title", analyzer).parse("dummy");
        TopDocs dummyEnResults = searcher.search(qDummyEn, 10);
        System.out.println("\n9a " + dummyEnResults.scoreDocs.length + " matching");

        for (ScoreDoc sd : dummyEnResults.scoreDocs) {
            Document d = searcher.storedFields().document(sd.doc);
            System.out.println("  " + d.get("title"));
        }

        // 9b
        Query qAndEn = new QueryParser("title", analyzer).parse("and");
        TopDocs andEnResults = searcher.search(qAndEn, 10);
        System.out.println("\n9b " + andEnResults.scoreDocs.length + " matching");

        for (ScoreDoc sd : andEnResults.scoreDocs) {
            Document d = searcher.storedFields().document(sd.doc);
            System.out.println("  " + d.get("title"));
        }



        Analyzer polishAnalyzer = new PolishAnalyzer();
        Directory polishDirectory = new ByteBuffersDirectory();
        IndexWriterConfig polishConfig = new IndexWriterConfig(polishAnalyzer);
        IndexWriter polishWriter = new IndexWriter(polishDirectory, polishConfig);

        polishWriter.addDocument(buildDoc("Lucyna w akcji", "9780062316097"));
        polishWriter.addDocument(buildDoc("Akcje rosną i spadają", "9780385545955"));
        polishWriter.addDocument(buildDoc("Bo ponieważ", "9781501168007"));
        polishWriter.addDocument(buildDoc("Naturalnie urodzeni mordercy", "9780316485616"));
        polishWriter.addDocument(buildDoc("Druhna rodzi", "9780593301760"));
        polishWriter.addDocument(buildDoc("Urodzić się na nowo", "9780679777489"));

        polishWriter.close();

        IndexReader polishReader = DirectoryReader.open(polishDirectory);
        IndexSearcher polishSearcher = new IndexSearcher(polishReader);

        // 11a
        Query qDummyPl = new QueryParser("title", polishAnalyzer).parse("dummy");
        TopDocs dummyPlResults = polishSearcher.search(qDummyPl, 10);
        System.out.println("\n11a " + dummyPlResults.scoreDocs.length + " matching");

        for (ScoreDoc sd : dummyPlResults.scoreDocs) {
            Document d = polishSearcher.storedFields().document(sd.doc);
            System.out.println("  " + d.get("title"));
        }

        // 11b
        Query qAndPl = new QueryParser("title", polishAnalyzer).parse("and");
        TopDocs andPlResults = polishSearcher.search(qAndPl, 10);
        System.out.println("\n11b " + andPlResults.scoreDocs.length + " matching");

        for (ScoreDoc sd : andPlResults.scoreDocs) {
            Document d = polishSearcher.storedFields().document(sd.doc);
            System.out.println("  " + d.get("title"));
        }

        reader.close();

        // 12a
        runQuery("12a – isbn = 9780062316097", "isbn:\"9780062316097\"", polishAnalyzer, polishSearcher);

        // 12b
        runQuery("12b – urodzić", "urodzić", polishAnalyzer, polishSearcher);

        // 12c
        runQuery("12c – rodzić", "rodzić", polishAnalyzer, polishSearcher);

        // 12d
        runQuery("12d – ro*", "ro*", polishAnalyzer, polishSearcher);

        // 12e
        runQuery("12e – ponieważ", "ponieważ", polishAnalyzer, polishSearcher);

        // 12f
        runQuery("12f – Lucyna AND akcja",
                "Lucyna AND akcja", polishAnalyzer, polishSearcher);

        // 12g
        runQuery("12g – akcja NOT Lucyna",
                "akcja NOT Lucyna", polishAnalyzer, polishSearcher);

        // 12h
        runQuery("12h – naturalnie~2 morderca",
                "\"naturalnie morderca\"~3", polishAnalyzer, polishSearcher);

        // 12i
        runQuery("12i – naturalnie~1 morderca",
                "\"naturalnie morderca\"~2", polishAnalyzer, polishSearcher);

        // 12j
        runQuery("12j – \"naturalnie morderca\"",
                "\"naturalnie morderca\"", polishAnalyzer, polishSearcher);

        // 12k
        runQuery("12k – naturalne", "naturalne", polishAnalyzer, polishSearcher);

        // 12l
        runQuery("12l – naturalne~1", "naturalne~1", polishAnalyzer, polishSearcher);


        polishReader.close();
    }
}
