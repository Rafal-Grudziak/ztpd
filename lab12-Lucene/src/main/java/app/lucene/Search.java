package app.lucene;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.pl.PolishAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.DirectoryReader;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.StoredFields;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.search.*;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;

import java.nio.file.Path;
import java.nio.file.Paths;

public class Search {

    private static final String INDEX_DIRECTORY = "lucene_index";

    public static void main(String[] args) throws Exception {

        String queryStr = (args.length > 0) ? args[0] : "*:*";

        Path indexPath = Paths.get(INDEX_DIRECTORY);
        Directory directory = FSDirectory.open(indexPath);

        Analyzer analyzer = new PolishAnalyzer();

        IndexReader reader = DirectoryReader.open(directory);
        IndexSearcher searcher = new IndexSearcher(reader);

        Query q = new QueryParser("title", analyzer).parse(queryStr);

        TopDocs docs = searcher.search(q, 10);
        ScoreDoc[] hits = docs.scoreDocs;

        System.out.println("Query: " + queryStr);
        System.out.println("Found " + hits.length + " matching docs.");

        StoredFields storedFields = searcher.storedFields();
        for (int i = 0; i < hits.length; i++) {
            Document d = storedFields.document(hits[i].doc);
            System.out.println((i + 1) + ". " + d.get("isbn") + "\t" + d.get("title"));
        }

        reader.close();
        directory.close();
    }
}
