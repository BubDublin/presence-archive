

module.exports = function (eleventyConfig) {
  // Copy assets to output
  eleventyConfig.addPassthroughCopy("assets");
  eleventyConfig.addPassthroughCopy("site/assets");

  // Define content collections
  eleventyConfig.addCollection("loops", (collection) =>
    collection.getFilteredByGlob("loops/*.md")
  );
  eleventyConfig.addCollection("whitepapers", (collection) =>
    collection.getFilteredByGlob("site/signal/white-papers/*.md")
  );
  eleventyConfig.addCollection("protocols", (collection) =>
    collection.getFilteredByGlob("site/signal/protocols/*.md")
  );
  eleventyConfig.addCollection("analysis", (collection) =>
    collection.getFilteredByGlob("site/signal/analysis/*.md")
  );
  eleventyConfig.addCollection("reference", (collection) =>
    collection.getFilteredByGlob("site/signal/reference/*.md")
  );

  return {
    dir: {
      input: "site",
      includes: "../_includes",
      output: "docs"
    },
    markdownTemplateEngine: "njk",
    htmlTemplateEngine: "njk",
    templateFormats: ["md", "njk"]
  };
};